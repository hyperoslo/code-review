require "test_helper"

class GitHubTest < MiniTest::Unit::TestCase

  def test_diff
    url = "http://example.from.github.com/repository/commit/2637cc74485"

    HTTParty.
      expects(
        :get
      ).
      with(
        "#{url}.diff"
      ).
      returns(
        stub code: 200, body: "<diff>"
      )

    GitHub.diff url
  end

  def test_unexpected_response
    url = "http://example.from.github.com/repository/commit/2637cc74485"

    HTTParty.
      expects(
        :get
      ).
      returns(
        stub code: 401
      )

    assert_raises GitService::Error do
      GitHub.diff url
    end
  end
end
