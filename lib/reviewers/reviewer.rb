module Reviewers

  class Reviewer
    attr_reader :email, :aliases, :groups

    # Initialize a new reviewer.
    #
    # email   	- A String describing the reviewer's primary e-mail address.
    # aliases 	- An Array of Strings describing the reviewer's secondary e-mail addresses (if any).
    # groups - An Array of Strings describing the reviewer's groups
    def initialize email, aliases, groups
      @email   = email
      @aliases = aliases
      @groups = groups
    end

    # Returns an Array of Strings describing the reviewer's e-mail addresses.
    def emails
      [@email] + @aliases
    end

    def groups
    	@groups
    end

    #
    #
    # groups - An Array of groups.
    #
    # Returns a boolean
    def has_groups? groups
      has_groups = groups.map do |group|
      	self.groups.include? group
      end
      return true if has_groups.include? true
    end

    # Returns true if the reviewer has the group
    def has_group? group
			@groups.include? group
    end

  end

end
