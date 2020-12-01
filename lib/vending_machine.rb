class VendingMachine
  attr_reader :inventory, :change

  def initialize(inventory, change)
    @inventory = inventory
    @change = change
  end

  def display_inventory
    inventory.each_with_index do |product, index|
      puts format_product_for_display(product, index)
    end
  end

  private

  def format_product_for_display(product, index)
    "Code #{index + 1}: #{product.name} - Price: #{product.price}"
  end
end
