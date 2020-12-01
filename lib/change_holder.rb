class ChangeHolder
  VALID_COIN_VALUES = [200, 100, 50, 10, 20, 5, 2, 1].freeze

  attr_accessor :coins

  def initialize(coins)
    @coins = coins
  end

  def insert_coin(value, amount = 1)
    unless VALID_COIN_VALUES.include?(value)
      raise "Invalid coin provided"
    end
    @coins[value] += amount
  end
end
