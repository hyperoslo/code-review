module Reviewers
  autoload :Reviewer, "reviewers/reviewer"

  class << self
    include Enumerable

    @reviewers = []

    def each &block
      @reviewers.each &block
    end

    # Find reviewers eligible to review the given e-mail address.
    #
    # email - A String describing an e-mail address.
    #
    # Returns an Array of Reviewer instances.
    def for email
      reject do |reviewer|
        reviewer.emails.include? email
      end
    end

    # Load reviewers.
    #
    # reviewers - A String describing a comma- and colon-separated list of
    #             reviewers (see the documentation for details).
    def load reviewers
      @reviewers = reviewers.split(",").map do |reviewer|
        addresses = reviewer.split ":"

        Reviewer.new addresses.shift, addresses
      end
    end
  end

end
