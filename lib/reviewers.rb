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
    # email 	- A String describing an e-mail address.
    # groups 	- An Array of groups.
    #
    # Returns an Array of Reviewer instances.
    def for email, groups=nil
    	if groups
    		select do |reviewer|
	        reviewer.has_groups? groups and !reviewer.emails.include? email
	      end
    	else
	      reviewers = reject do |reviewer|
	        reviewer.groups.size > 0 or	reviewer.emails.include? email
	      end
    	end
    end

    # Load reviewers.
    #
    # reviewers - A String describing a comma- , colon- and semicolon-seperated list of
    #             reviewers (see the documentation for details).
    def load reviewers
      @reviewers = reviewers.split(",").map do |reviewer|
        addresses = reviewer.split ":"
        groups = []

        # look for groups
        addresses.reject! do |address|
	        if address.include? ";"
	        	groups = address.split ";"
	        	addresses << groups.shift    # put last email before groups back into address array
	        end
        end

        Reviewer.new addresses.shift, addresses, groups
      end
    end
  end

end
