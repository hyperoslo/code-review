require "test_helper"

class GitLabTest < MiniTest::Unit::TestCase
  def test_configure
    GitLab.configure do |config|
      config.private_token = "<private token>"
    end
    
    assert_equal "<private token>", GitLab.private_token
  end

  def test_diff
    url = "http://git.example.org/repository/commit/2637cc74485"

    HTTParty.
      expects(
        :get
      ).
      with(
        "#{url}.diff", query: {
          private_token: GitLab.private_token
        }
      ).
      returns(
        stub code: 200, body: "<diff>"
      )

    GitLab.diff url
  end

  def test_unexpected_response
    url = "http://git.example.org/repository/commit/2637cc74485"

    HTTParty.
      expects(
        :get
      ).
      returns(
        stub code: 401
      )

    assert_raises GitLab::Error do
      GitLab.diff url
    end
  end
end
