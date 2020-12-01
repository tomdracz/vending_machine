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
end
