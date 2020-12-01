require_relative '../lib/vending_machine'
require_relative '../lib/product'

RSpec.describe VendingMachine do
  let(:inventory) { double('inventory') }
  let(:change) { double('change') }
  subject { described_class.new(inventory, change) }
  describe '#initialize' do
    it 'has an inventory' do
      expect(subject.inventory).to eq(inventory)
    end

    it 'has a change' do
      expect(subject.change).to eq(change)
    end
  end

  describe '#display_inventory' do
    let(:inventory) do
      [
        Product.new('Crisps', 60, 10),
        Product.new('Coke', 70, 10),
        Product.new('Dr Pepper', 70, 0)
      ]
    end
    it 'shows the selection of current products with their prices' do
      expectation = expect { subject.display_inventory }
      expectation.to output(/Crisps.*60/).to_stdout
      expectation.to output(/Coke.*70/).to_stdout
      expectation.to output(/Dr Pepper.*70/).to_stdout
    end
  end
end
