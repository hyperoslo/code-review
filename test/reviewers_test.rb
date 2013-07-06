require "test_helper"
require "reviewers"

class ReviewersTest < MiniTest::Unit::TestCase
  def setup
    Reviewers.load "me@work:me@home:me@road;ruby;javascript,you@work:you@home,him@work:him@home;ruby,her@work:her@home;python"
  end

  def test_load
    assert_equal 4, Reviewers.entries.size

    reviewer = Reviewers.entries.first

    assert_equal "me@work", reviewer.email
    assert_equal ["me@home", "me@road"], reviewer.aliases
    assert_equal ["ruby", "javascript"], reviewer.groups
  end

  def test_for
    reviewers = Reviewers.for "me@home"

    assert_equal 1, reviewers.size
    assert_equal "you@work", reviewers.first.email
  end

  def test_for_with_groups
    reviewers = Reviewers.for "me@home", ["ruby", "python"]

    assert_equal 2, reviewers.size
    assert_equal "him@work", reviewers.first.email
  end
end
