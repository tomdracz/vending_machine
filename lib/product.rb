require_relative './vending_machine_exceptions'

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
    raise VendingMachineExceptions::ProductRemoveError if amount > quantity

    @quantity -= amount
  end

  def available?
    quantity > 0
  end
end
