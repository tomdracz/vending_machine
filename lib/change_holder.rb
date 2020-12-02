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

  def calculate_change(product_price, inserted_sum)
    change_required = inserted_sum - product_price
    returned_change = []
    remaining = change_required
  
    coins.each do |coin_value, coin_quantity|
      next unless coin_value <= remaining && coin_quantity > 0

      loop_times = [(remaining / coin_value), coin_quantity].min
      loop_times.times do
        returned_change << coin_value
        remaining -= coin_value
        return_coin(coin_value)
      end
    end

    if returned_change.sum != change_required
      returned_change.each do |coin_value|
        insert_coin(coin_value)
      end
      raise VendingMachineExceptions::NotEnoughChange
    end
    
    returned_change
  end
end
