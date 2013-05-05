class GitService

  class << self

    def diff url
      url.downcase.include?( 'github.com' ) ? GitHub.diff(url) : GitLab.diff(url)
    end

    def configure
      yield self
    end

    def handle_response response
      if response.code == 200
        response.body
      else
        raise Error, "Received unexpected status code #{response.code} from #{self.name}"
      end
    end

  end

  class Error < StandardError; end
end
