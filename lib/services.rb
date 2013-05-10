module Services
  require "services/service"
  require "services/github"
  require "services/gitlab"

  class << self
    include Enumerable

    SERVICES = [
      Services::GitHub,
      Services::GitLab
    ]

    # Find the service identified by the given name.
    #
    # name - A String describing a service.
    #
    # Returns a Service instance.
    def lookup name
      find do |service|
        service.name == name
      end or raise UnknownService, "Could not find service '#{name}'"
    end

    def each &block
      SERVICES.each &block
    end
  end

  class UnknownService < StandardError; end
end
