require "test_helper"

class ApplicationTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_github
    Services::GitHub.
      expects(
        :diff
      )

    Pony.
      expects(
        :mail
      ).
      with(
        has_entries(
          to: "tim@hyper.no",
          reply_to: "johannes@hyper.no",
          cc: "johannes@hyper.no",
          subject: "Code review for testing/master@c441029",
          from: "Hyper <no-reply@hyper.no>"
        )
      )

    json = fixture "github.json"

    post "/?service=github", payload: json
  end

  def test_gitlab
    Services::GitLab.
      expects(
        :diff
      )

    Pony.
      expects(
        :mail
      ).
      with(
        has_entries(
          to: "tim@hyper.no",
          reply_to: "johannes@hyper.no",
          cc: "johannes@hyper.no",
          subject: "Code review for Diaspora/master@b6568db",
          from: "Hyper <no-reply@hyper.no>"
        )
      )

    json = fixture "gitlab.json"

    post "/?service=gitlab", json
  end

  def test_guaranteed_review
    commit = {"message" => "Test. Please review this."}
    assert guaranteed_review?(commit), "Should guarantee a review."
  end

  def test_gitlab_guaranteed_review
    Services::GitLab.
      expects(
        :diff
      )

    Pony.
      expects(
        :mail
      ).
      with(
        has_entries(
          to: "tim@hyper.no",
          reply_to: "johannes@hyper.no",
          cc: "johannes@hyper.no",
          subject: "Code review for Diaspora/master@b6568db",
          from: "Hyper <no-reply@hyper.no>"
        )
      )

    json = fixture "gitlab.json"

    # Make sure the fixture includes the guarantee string
    json.sub! "Update Catalan translation to e38cb41.", "Test. Please review."

    # Configure odds to never deliver code reviews
    set :odds, "0:0"

    post "/?service=gitlab", json

    # Configure odds to deliver code reviews again
    set :odds, ENV["ODDS"]
  end
end
