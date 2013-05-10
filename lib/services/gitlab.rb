module Services

  class GitLab < Service

    class << self
      attr_accessor :private_token

      # Parse the given request.
      #
      # response - A Sinatra::Request instance.
      #
      # Returns a Hash describing the payload.
      def parse_request request
        JSON.parse request.body.read
      end

      def name
        "gitlab"
      end

      # Query the diff for a given commit.
      #
      # url - A String describing a URL to a commit.
      #
      # Returns a String.
      def diff url
        parse_response HTTParty.get "#{url}.diff", query: {
          private_token: @private_token
        }
      end

    end
  end

end
