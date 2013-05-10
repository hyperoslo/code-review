require "test_helper"

class Services::GitLabTest < MiniTest::Unit::TestCase
  def test_parse_request
    body    = stub read: "{\"foo\": \"bar\"}"
    request = stub body: body

    hash = Services::GitLab.parse_request request

    assert_equal hash, { "foo" => "bar" }
  end

  def test_name
    assert_equal "gitlab", Services::GitLab.name
  end

  def test_diff
    Services::GitLab.
      stubs(
        :parse_response
      )

    HTTParty.
      expects(
        :get
      ).
      with(
        "http://example.org/commit.diff", query: {
          private_token: nil
        }
      )

    Services::GitLab.diff "http://example.org/commit"
  end
end
