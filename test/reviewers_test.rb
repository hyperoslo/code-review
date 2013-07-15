require "test_helper"
require "reviewers"

class ReviewersTest < MiniTest::Unit::TestCase
  def setup
    Reviewers.load "me@work:me@home:me@road,you@work:you@home,them@work:them@home:them@road;ruby;javascript,they@work,him@work:him@home;ruby,her@work:her@home;python"
  end

  def test_load
    assert_equal 6, Reviewers.entries.size

    reviewer = Reviewers.entries.third

    assert_equal "them@work", reviewer.email
    assert_equal ["them@home", "them@road"], reviewer.aliases
    assert_equal ["ruby", "javascript"], reviewer.groups
  end

  def test_for_without_groups
    reviewers = Reviewers.for "me@home"

    assert_equal 2, reviewers.size
    assert_equal "you@work", reviewers.first.email
  end

  def test_for_with_groups
    reviewers = Reviewers.for "me@home", ["ruby", "python"]

    assert_equal 3, reviewers.size
    assert_equal "them@work", reviewers.first.email
  end
end
