require "test_helper"

class GitServiceTest < MiniTest::Unit::TestCase

  def test_service_diff_for_github_url
    url = "http://example.from.github.com/repository/commit/2637cc74485"
    GitHub.expects(:diff)
    GitLab.expects(:diff).never
    GitService.diff url
  end

  def test_service_diff_for_gitlab_url
    url = "http://git.example.org/repository/commit/2637cc74485"
    GitLab.expects(:diff)
    GitHub.expects(:diff).never
    GitService.diff url
  end

end
