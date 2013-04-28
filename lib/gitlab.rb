class GitLab

  class << self
    attr_accessor :private_token

    # Query the diff for a given commit.
    #
    # url - A String describing a URL to a commit.
    #
    # Returns a String.
    def diff url
      response = HTTParty.get "#{url}.diff", query: {
        private_token: @private_token
      }

      if response.code == 200
        response.body
      else
        raise Error, "Received unnexpected status code #{response.code} from GitLab"
      end
    end

    def configure
      yield self
    end
  end

  class Error < StandardError; end
end
