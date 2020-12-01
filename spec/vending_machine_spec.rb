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

  describe '#get_customer_selection' do
    it 'stores customer selection in a variable as index of selected product' do
      allow(STDIN).to receive(:gets) { '1' }
      expect(subject.get_customer_selection).to eq(0)
    end

    it 'prints an error if invalid code is selected' do
      allow(STDIN).to receive(:gets) { 'foobar' }
      allow(STDOUT).to receive(:puts)
      subject.get_customer_selection
      expect(subject.customer_selection).to be_nil
      expect(STDOUT).to have_received(:puts).with(/Invalid code selected/)
    end

    it 'prints an error if valid index is provided, but not matching any product' do
      allow(STDIN).to receive(:gets) { '4' }
      allow(STDOUT).to receive(:puts)
      subject.get_customer_selection
      expect(subject.customer_selection).to be_nil
      expect(STDOUT).to have_received(:puts).with(/Invalid code selected/)
    end
  end
end
