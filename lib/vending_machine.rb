require_relative './vending_machine_exceptions'

class VendingMachine
  include VendingMachineExceptions

  attr_reader :inventory, :change, :customer_selection, :selected_product, :inserted_coins

  def initialize(inventory, change)
    @inventory = inventory
    @change = change
    @customer_selection = nil
    @selected_product = nil
    @inserted_coins = []
  end

  def vend
    loop do
      display_inventory
      get_customer_selection
      collect_coins
      dispense_product
      return_change
    end
  end

  def display_inventory
    inventory.each_with_index do |product, index|
      puts format_product_for_display(product, index)
    end
  end

  def get_customer_selection
    loop do
      break if @customer_selection
      selection = STDIN.gets.chomp
      product_index = selection.to_i - 1
      if product_index >= 0 && product_index < inventory.size
        @selected_product = inventory[product_index]
        @customer_selection = product_index
      else
        puts 'Invalid code selected. Please try again'
      end
    end
  end

  def collect_coins
    price = selected_product.price
    collected_coins = []
    loop do
      break if collected_coins.sum >= price

      inserted_coin = STDIN.gets.chomp.to_i
      begin
        change.insert_coin(inserted_coin)
        collected_coins << inserted_coin
      rescue VendingMachineExceptions::InvalidCoinError
        puts 'Invalid coin inserted, please try again'
      end
    end
    @inserted_coins = collected_coins
  end

  def dispense_product
    selected_product.remove
    puts "Here's your product: #{selected_product.name}"
  end

  def return_change
    inserted_sum = inserted_coins.sum
    product_price = selected_product.price
    returned_change = change.calculate_change(product_price, inserted_sum)
    puts "Here's your change: #{returned_change}"
  end

  private

  def format_product_for_display(product, index)
    "Code #{index + 1}: #{product.name} - Price: #{product.price}"
  end
end
