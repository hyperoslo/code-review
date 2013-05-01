require "test_helper"
require "reviewers/reviewer"

class Reviewers::ReviewerTest < MiniTest::Unit::TestCase
  include Reviewers

  def test_emails
    reviewer = Reviewer.new "me@work", ["me@home"]

    assert_equal ["me@work", "me@home"], reviewer.emails
  end
end
