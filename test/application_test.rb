require "test_helper"

class ApplicationTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_sends_email
    GitLab.
      expects(
        :diff
      )

    Pony.
      expects(
        :mail
      ).
      with(
        has_entries(
          to: "tim@hyper.no",
          reply_to: "johannes@hyper.no",
          cc: "johannes@hyper.no",
          subject: "Code review for Diaspora/master@b6568db",
          from: "Hyper <no-reply@hyper.no>"
        )
      )

    post "/", fixture("gitlab.json")
  end

  def test_github_webhook
    Pony.stubs(:mail).returns true
    GitHub.stubs(:diff)
    post "/", payload: fixture("github.json")
  end
end
