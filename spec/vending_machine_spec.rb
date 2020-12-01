require_relative "../lib/vending_machine"

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
end
