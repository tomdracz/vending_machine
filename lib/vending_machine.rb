class VendingMachine
  attr_reader :inventory, :change

  def initialize(inventory, change)
    @inventory = inventory
    @change = change
  end
end
