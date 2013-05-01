require "test_helper"

class OddsTest < MiniTest::Unit::TestCase
  def test_roll
    roll = Odds.roll "1:1"

    assert_equal true, roll
  end

  def test_parse
    chance = Odds.parse "1:2"

    assert_equal 50, chance
  end
end
