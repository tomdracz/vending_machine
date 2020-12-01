class Product
  attr_reader :name, :price, :quantity

  def initialize(name, price, quantity = 1)
    @name = name
    @price = price
    @quantity = quantity
  end

  def restock(amount = 1)
    @quantity += amount
  end

  def remove(amount = 1)
    raise 'Cannot remove more products then available' if amount > quantity

    @quantity -= amount
  end

  def available?
    quantity > 0
  end
end
