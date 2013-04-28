module Odds
  extend self

  # Do you feel lucky, punk?
  #
  # string - A String describing the odds.
  #
  # Returns a Boolean describing whether the roll was successful.
  def roll string
    pool     = rand 100
    fraction = parse string

    pool <= fraction
  end

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
