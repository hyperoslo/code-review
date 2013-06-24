module Services

  class GitHub < Service

    class << self
      # Parse the given request.
      #
      # response - A Sinatra::Request instance.
      #
      # Returns a Hash describing the payload.
      def parse_request request
        payload = request.params.fetch "payload"

        JSON.parse payload
      end

      def name
        "github"
      end

      # Query the diff for a given commit.
      #
      # url - A String describing a URL to a commit.
      #
      # Returns a String.
      def diff url
        parse_response HTTParty.get "#{url}.diff"
      end
    end

  end

end
