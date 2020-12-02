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
      display_welcome_message
      display_inventory
      get_customer_selection
      collect_coins
      dispense_product
      return_change
    end
  end

  def display_welcome_message
    puts "Welcome to the Vending Machine. Please see the products available"
  end

  def display_inventory
    inventory.each_with_index do |product, index|
      puts format_product_for_display(product, index)
    end
  end

  def get_customer_selection
    puts "Please enter the code of the item you wish to purchase"

    loop do
      break if @customer_selection
      selection = STDIN.gets.chomp
      product_index = selection.to_i - 1
      if product_index >= 0 && product_index < inventory.size && inventory[product_index].available?
        @selected_product = inventory[product_index]
        @customer_selection = product_index
      else
        puts 'Invalid code selected. Please try again'
      end
    end
  end

  def collect_coins
    puts "Please insert your coins entering pence value of a coin (i.e. 100 for £1)"
    price = selected_product.price
    collected_coins = []
    loop do
      break if collected_coins.sum >= price
      puts "Product price is: #{price}. Inserted #{collected_coins.sum} so far"

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
  
    return if inserted_sum == product_price

    returned_change = change.calculate_change(product_price, inserted_sum)
    puts "Here's your change: #{returned_change}"
  end

  def reload_products
    puts "Here are the current products"
    display_inventory
    puts "Please enter the code of the item you want to reload"
    reload_selection = nil
    reload_quantity = nil

    loop do
      break if reload_selection
      selection_input = STDIN.gets.chomp
      product_index = selection_input.to_i - 1
      if product_index >= 0 && product_index < inventory.size
        reload_selection = product_index
      else
        puts 'Invalid code selected. Please try again'
      end
    end

    puts "Enter the quantity you are reloading the item by"

    loop do
      break if reload_quantity
      quantity_input = STDIN.gets.chomp
      if quantity_input.to_i > 0
        reload_quantity = quantity_input.to_i
      else
        puts "Invalid quantity entered. Must be a valid number above 0"
      end
    end
    
    if reload_selection && reload_quantity
      inventory[reload_selection].restock(reload_quantity)
    end
    reload_selection = nil
    reload_quantity = nil

    puts "Restocked!"
  end

  private

  def format_product_for_display(product, index)
    if product.available?
      "Code #{index + 1}: #{product.name} - Price: #{product.price}"
    else
      "Code #{index + 1}: #{product.name} - Price: SOLD OUT"
    end
  end
end
