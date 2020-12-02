require_relative './lib/vending_machine'
require_relative './lib/product'
require_relative './lib/change_holder'

inventory = [
  Product.new('Mars Bar', 40, 10),
  Product.new('Snickers', 45, 10),
  Product.new('Twix', 45, 4),
  Product.new('Galaxy', 50, 3),
  Product.new('Coke', 70, 10),
  Product.new('Dr Pepper', 70, 0)
]

change = ChangeHolder.new({
  200 => 20,
  100 => 20,
  50 => 20,
  20 => 20,
  10 => 20,
  5 => 20,
  2 => 20,
  1 => 20
})

machine = VendingMachine.new(inventory, change)

machine.vend