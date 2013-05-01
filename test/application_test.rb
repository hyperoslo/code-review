require "test_helper"

class ApplicationTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_sends_email
    payload = {
      before: "95790bf891e76fee5e1747ab589903a6a1f80f22",
      after: "da1560886d4f094c3e6c9ef40349f7d38b5d27d7",
      ref: "refs/heads/master",
      user_id: 4,
      user_name: "John Smith",
      repository: {
        name: "Diaspora",
        url: "localhost/diaspora",
        description: "",
        homepage: "localhost/diaspora",
        private: true
      },
      commits: [
        {
          id: "b6568db1bc1dcd7f8b4d5a946b0b91f9dacd7327",
          message: "Update Catalan translation to e38cb41.",
          timestamp: "2011-12-12T14:27:31+02:00",
          url: "http://localhost/diaspora/commits/b6568db1bc1dcd7f8b4d5a946b0b91f9dacd7327",
          author: {
           name: "Johannes Gorset",
           email: "johannes@hyper.no"
          }
        }
      ]
    }

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
          cc: "johannes@hyper.no",
          subject: "Code review",
          from: "Hyper <no-reply@hyper.no>"
        )
      )

    post "/", payload.to_json
  end

  def test_github_webhook
    Pony.stubs(:mail).returns true
    post "/", payload: github_payload.to_json
  end

  def test_github_payload_structure_resembles_the_one_from_gitlab
    commit = github_payload[:commits].first
    assert_equal 'lolwut@noway.biz', commit[:author][:email], "Couldn't find the author's email. Is this really from Github?"
    assert_equal 'Garen Torikian', commit[:author][:name], "Couldn't find the commit author's name either"
    expected_url = 'https://github.com/octokitty/testing/commit/c441029cf673f84c8b7db52d0a5944ee5c52ff89'
    assert_equal expected_url, commit[:url], "Expected url was not found in the payload"
  end
end
