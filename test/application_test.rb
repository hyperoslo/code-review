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
          id: "450d0de7532f8b663b9c5cce183b...",
          message: "Update Catalan translation to e38cb41.",
          timestamp: "2011-12-12T14:27:31+02:00",
          author: {
           name: "Johannes Gorset",
           email: "johannes@hyper.no"
          },
          committer: {
           name: "Johannes Gorset",
           email: "johannes@hyper.no"
          }
        }
      ]
    }

    Pony.
      expects(
        :mail
      ).
      with(
        has_entries(
          to: any_of("tim@hyper.no", "johannes@hyper.no", "espen@hyper.no"),
          subject: "You've been selected to review Johannes Gorset's commit",
          from: "Hyper <no-reply@hyper.no>"
        )
      )

    Pony.
      expects(
        :mail
      ).
      with(
        has_entries(
          to: "johannes@hyper.no",
          subject: "Your commit has been selected for review",
          from: "Hyper <no-reply@hyper.no>"
        )
      )

    post "/", payload.to_json
  end
end
