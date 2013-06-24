module Reviewers

  class Reviewer
    attr_reader :email, :aliases

    # Initialize a new reviewer.
    #
    # email   - A String describing the reviewer's primary e-mail address.
    # aliases - An Array of Strings describing the reviewer's secondary e-mail addresses (if any).
    def initialize email, aliases
      @email   = email
      @aliases = aliases
    end

    # Returns an Array of Strings describing the reviewer's e-mail addresses.
    def emails
      [@email] + @aliases
    end

  end

end
