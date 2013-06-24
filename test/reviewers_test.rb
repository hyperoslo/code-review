require "test_helper"
require "reviewers"

class ReviewersTest < MiniTest::Unit::TestCase
  def setup
    Reviewers.load "me@work:me@home:me@road,you@work:you@home"
  end

  def test_load
    assert_equal 2, Reviewers.entries.size

    reviewer = Reviewers.entries.first

    assert_equal "me@work", reviewer.email
    assert_equal ["me@home", "me@road"], reviewer.aliases
  end

  def test_for
    reviewers = Reviewers.for "me@home"

    assert_equal 1, reviewers.size
    assert_equal "you@work", reviewers.first.email
  end
end
