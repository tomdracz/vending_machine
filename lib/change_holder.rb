require_relative './vending_machine_exceptions'

class ChangeHolder
  include VendingMachineExceptions

  VALID_COIN_VALUES = [200, 100, 50, 10, 20, 5, 2, 1].freeze

  attr_accessor :coins

  def initialize(coins)
    @coins = coins
  end

  def insert_coin(value, amount = 1)
    raise VendingMachineExceptions::InvalidCoinError unless VALID_COIN_VALUES.include?(value)

    coins[value] += amount
  end

  def return_coin(value, amount = 1)
    raise VendingMachineExceptions::InvalidCoinError unless VALID_COIN_VALUES.include?(value)

    raise VendingMachineExceptions::CoinReturnError if amount > coins[value]

    coins[value] -= amount
    Array.new(amount, value)
  end
end
