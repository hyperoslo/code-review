module Services

  class Service

    class << self

      def configure
        yield self
      end

      # Parse the given response.
      #
      # response - A HTTParty::Response instance.
      #
      # Returns a String describing the response body, or raises
      # a Service::Error upon a non-200 response.
      def parse_response response
        if response.code == 200
          response.body
        else
          raise Error, "Received unexpected status code #{response.code}"
        end
      end

    end

    class Error < StandardError; end
  end

end
