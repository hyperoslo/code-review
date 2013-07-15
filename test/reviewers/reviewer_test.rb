require "test_helper"
require "reviewers/reviewer"

class Reviewers::ReviewerTest < MiniTest::Unit::TestCase
  include Reviewers

  def test_emails
    reviewer = Reviewer.new "me@work", ["me@home"], ["ruby", "javascript"]

    assert_equal ["me@work", "me@home"], reviewer.emails
  end

  def test_groups
  	reviewer = Reviewer.new "me@work", ["me@home"], ["ruby", "javascript"]

    assert_equal ["ruby", "javascript"], reviewer.groups
  end

  def test_has_group
		reviewer = Reviewer.new "me@work", ["me@home"], ["ruby", "javascript"]

		assert reviewer.has_group?("ruby"), "Does not have the given group"
  end

  def test_has_groups
		reviewer = Reviewer.new "me@work", ["me@home"], ["ruby", "javascript"]

		assert reviewer.has_groups?(["ruby", "javascript"]), "Does not have any of the given groups"
  end
end
