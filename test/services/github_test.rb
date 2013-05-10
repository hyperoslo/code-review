require "test_helper"

class Services::GitHubTest < MiniTest::Unit::TestCase
  def test_parse_request
    request = stub params: {
      "payload" => "{\"foo\": \"bar\"}"
    }

    hash = Services::GitHub.parse_request request

    assert_equal hash, { "foo" => "bar" }
  end

  def test_name
    assert_equal "github", Services::GitHub.name
  end

  def test_diff
    Services::GitHub.
      stubs(
        :parse_response
      )

    HTTParty.
      expects(
        :get
      ).
      with(
        "http://example.org/commit.diff"
      )

    Services::GitHub.diff "http://example.org/commit"
  end
end
