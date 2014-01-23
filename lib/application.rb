require "sinatra"
require "json"
require "pony"
require "httparty"
require "pygments"
require "gravatar"
require "odds"
require "services"
require "reviewers"
require "premailer"
require "helpers"

configure do
  set :odds, ENV["ODDS"]
  set :gitlab_private_token, ENV["GITLAB_PRIVATE_TOKEN"]
  set :reviewers, ENV["REVIEWERS"]
  set :sender, ENV["SENDER"]
  set :guaranteed_review, ENV["GUARANTEED_REVIEW"] || "please review"
end

Pony.options = {
  via: :smtp,
  via_options: {
    address: ENV["SMTP_HOST"],
    port: ENV["SMTP_PORT"],
    domain: ENV["SMTP_DOMAIN"],
    user_name: ENV['SMTP_USERNAME'],
    password: ENV['SMTP_PASSWORD'],
    authentication: :plain,
    enable_starttls_auto: true
  }
}

Services::GitLab.configure do |config|
  config.private_token = settings.gitlab_private_token
end

Reviewers.load settings.reviewers

#filtering params
before "/" do
  if params.include? "service"
    @service = Services.lookup params[:service]
  else
    warn "Queries that don't specify a service are deprecated."

    @service = Services::GitLab
  end

  @data = @service.parse_request request

  @repository = @data["repository"]["name"]
  @branch     = @data["ref"].split("/").last

  halt 412 unless valid_branch? @branch
end



post "/" do
  @data["commits"].each do |commit|
    if Odds.roll settings.odds or guaranteed_review? commit
      reviewers = Reviewers.for commit["author"]["email"]

      if reviewer = reviewers.sample
        diff     = @service.diff commit["url"]
        gravatar = Gravatar.new commit["author"]["email"]

        html = erb :mail, locals: {
          gravatar: gravatar,
          commit: commit,
          diff: diff
        }

        mail = Premailer.new html, with_html_string: true, input_encoding: "UTF-8"

        Pony.mail({
          to: reviewer.email,
          from: settings.sender,
          reply_to: commit["author"]["email"],
          cc: commit["author"]["email"],
          subject: "Code review for #{@repository}/#{@branch}@#{commit["id"][0,7]}",
          headers: {
            "Content-Type" => "text/html"
          },
          body: mail.to_inline_css
        })

      end
    end
  end

  ""
end

# Check if the commit should guarantee a review.
#
# commit - A hash describing a commit.
#
# Returns a boolean describing if a commit should be reviewed or not.
def guaranteed_review? commit
  commit["message"].downcase.include? settings.guaranteed_review.downcase
end

def valid_branch? branch
  if params[:only_branches].present?
    return false unless params[:only_branches].split(",").include?(branch)
  elsif params[:except_branches].present?
    return false if params[:except_branches].split(",").include?(branch)
  end
  true
end