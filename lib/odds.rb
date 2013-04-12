module Odds
  extend self

  # Parse odds.
  #
  # string - A String describing the odds.
  #
  # Returns an Integer describing the chance as percent.
  def parse string
    x, y = string.split ":"

    x.to_f / y.to_f * 100
  end
end
