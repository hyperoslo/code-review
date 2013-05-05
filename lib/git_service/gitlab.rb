class GitLab < GitService

  class << self
    attr_accessor :private_token

    # Query the diff for a given commit.
    #
    # url - A String describing a URL to a commit.
    #
    # Returns a String.
    def diff url
      gitlab_response = HTTParty.get "#{url}.diff", query: {
        private_token: @private_token
      }
      handle_response gitlab_response
    end

  end
end
