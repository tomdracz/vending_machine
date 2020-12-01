class VendingMachine
  attr_reader :inventory, :change, :customer_selection

  def initialize(inventory, change)
    @inventory = inventory
    @change = change
    @customer_selection = customer_selection
  end

  def display_inventory
    inventory.each_with_index do |product, index|
      puts format_product_for_display(product, index)
    end
  end

  def get_customer_selection
    selection = STDIN.gets.chomp
    product_index = selection.to_i - 1
    if product_index >= 0
      return @customer_selection = product_index
    else
      puts "Invalid code selected. Please try again"
    end
  end

  private

  def format_product_for_display(product, index)
    "Code #{index + 1}: #{product.name} - Price: #{product.price}"
  end
end
