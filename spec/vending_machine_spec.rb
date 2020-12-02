require_relative '../lib/vending_machine'
require_relative '../lib/product'

RSpec.describe VendingMachine do
  let(:inventory) do
    [
      Product.new('Crisps', 60, 10),
      Product.new('Coke', 70, 10),
      Product.new('Dr Pepper', 70, 0)
    ]
  end
  let(:product) { double('product') }
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
    it 'shows the selection of current products with their prices' do
      expectation = expect { subject.display_inventory }
      expectation.to output(/Crisps.*60/).to_stdout
      expectation.to output(/Coke.*70/).to_stdout
      expectation.to output(/Dr Pepper.*70/).to_stdout
    end
  end

  describe '#get_customer_selection' do
    before(:each) do
      allow(subject).to receive(:loop).and_yield
    end
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

  describe "#collect_coins" do
    before(:each) do
      allow(product).to receive(:price) { 100 }
      allow(subject).to receive(:selected_product) { product }
    end
    it 'allows customer to insert coins into the machine and returns entered coins' do
      allow(STDIN).to receive(:gets).and_return('50', '20', '20', '20')
      allow(change).to receive(:insert_coin)
      expect(subject.collect_coins).to eq([50, 20, 20, 20])
      expect(change).to have_received(:insert_coin).exactly(4).times
    end
    it 'print an error message if an invalid coin has been inserted' do
      allow(STDIN).to receive(:gets).and_return('50', '40')
      allow(change).to receive(:insert_coin).with(50)
      allow(change).to receive(:insert_coin).with(40).and_raise(VendingMachineExceptions::InvalidCoinError)
      allow(STDOUT).to receive(:puts)
      allow(subject).to receive(:loop).and_yield.and_yield
      expect(subject.collect_coins).to eq([50])
      expect(STDOUT).to have_received(:puts).with(/Invalid coin inserted, please try again/).once
    end
  end

  describe "#dispense_product" do
    before(:each) do
      allow(product).to receive(:name) { 'Crisps' }
      allow(product).to receive(:remove)
      allow(subject).to receive(:selected_product) { product }
      allow(STDOUT).to receive(:puts)   
    end

    it 'returns selected product to the customer' do
      subject.dispense_product
      expect(product).to have_received(:remove).once
      expect(STDOUT).to have_received(:puts).with("Here's your product: #{product.name}")
    end
  end

  describe "#return_change" do
    let(:inserted_coins) { [50, 20, 20, 20] }
    before(:each) do
      allow(product).to receive(:price) { 100 }
      allow(change).to receive(:calculate_change) { [10] }
      allow(STDOUT).to receive(:puts) 
      allow(subject).to receive(:inserted_coins) { inserted_coins }
      allow(subject).to receive(:selected_product) { product }
    end
    it 'returns correct change to the customer' do
      subject.return_change
      expect(change).to have_received(:calculate_change).with(100, 110)
      expect(STDOUT).to have_received(:puts).with("Here's your change: [10]")
    end
  end
end
