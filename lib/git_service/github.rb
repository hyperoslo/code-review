class GitHub < GitService

  class << self

    # Query the diff for a given commit.
    #
    # url - A String describing a URL to a commit.
    #
    # Returns a String.
    def diff url
      github_response = HTTParty.get "#{url}.diff"
      handle_response github_response
    end

  end
end
