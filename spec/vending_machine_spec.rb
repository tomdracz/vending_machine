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

  describe '#vend' do
    it 'runs through the vending cycle' do
      allow(subject).to receive(:display_welcome_message)
      allow(subject).to receive(:display_inventory)
      allow(subject).to receive(:get_customer_selection)
      allow(subject).to receive(:collect_coins)
      allow(subject).to receive(:dispense_product)
      allow(subject).to receive(:return_change)
      allow(subject).to receive(:loop).and_yield

      subject.vend

      expect(subject).to have_received(:display_welcome_message).once
      expect(subject).to have_received(:display_inventory).once
      expect(subject).to have_received(:get_customer_selection).once
      expect(subject).to have_received(:collect_coins).once
      expect(subject).to have_received(:dispense_product).once
      expect(subject).to have_received(:return_change).once
    end
  end

  describe '#display_welcome_message' do
    it 'displays welcome message in the output console' do
      expect { subject.display_welcome_message }.to output(/Welcome to the Vending Machine/).to_stdout
    end
  end

  describe '#display_inventory' do
    it 'shows the selection of current products with their prices' do
      expectation = expect { subject.display_inventory }
      expectation.to output(/Crisps.*60/).to_stdout
      expectation.to output(/Coke.*70/).to_stdout
      expectation.to output(/Dr Pepper.*SOLD OUT/).to_stdout
    end
  end

  describe '#get_customer_selection' do
    before(:each) do
      allow(subject).to receive(:loop).and_yield
      allow(STDOUT).to receive(:puts)
    end

    it 'displays info message' do
      allow(STDIN).to receive(:gets) { '1' }
      subject.get_customer_selection
      expect(STDOUT).to have_received(:puts).with(/Please enter the code of the item you wish to purchase/)
    end
    it 'stores customer selection in a variable as index of selected product' do
      allow(STDIN).to receive(:gets) { '1' }
      expect(subject.get_customer_selection).to eq(0)
    end

    it 'prints an error if invalid code is selected' do
      allow(STDIN).to receive(:gets) { 'foobar' }
      subject.get_customer_selection
      expect(subject.customer_selection).to be_nil
      expect(STDOUT).to have_received(:puts).with(/Invalid code selected/)
    end

    it 'prints an error if valid index is provided, but not matching any product' do
      allow(STDIN).to receive(:gets) { '4' }
      subject.get_customer_selection
      expect(subject.customer_selection).to be_nil
      expect(STDOUT).to have_received(:puts).with(/Invalid code selected/)
    end

    it 'prints an error if valid index is provided, but product is sold out' do
      allow(STDIN).to receive(:gets) { '3' }
      subject.get_customer_selection
      expect(subject.customer_selection).to be_nil
      expect(STDOUT).to have_received(:puts).with(/Invalid code selected/)
    end
  end

  describe '#collect_coins' do
    before(:each) do
      allow(STDOUT).to receive(:puts)
      allow(product).to receive(:price) { 100 }
      allow(subject).to receive(:selected_product) { product }
    end

    it 'displays info message' do
      allow(STDIN).to receive(:gets).and_return('50', '20', '20', '20')
      allow(change).to receive(:insert_coin)
      allow(subject).to receive(:loop).and_yield
      subject.collect_coins
      expect(STDOUT).to have_received(:puts).with(/Please insert your coins entering pence value of a coin/)
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
      allow(subject).to receive(:loop).and_yield.and_yield
      expect(subject.collect_coins).to eq([50])
      expect(STDOUT).to have_received(:puts).with(/Invalid coin inserted, please try again/).once
    end
  end

  describe '#dispense_product' do
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

  describe '#return_change' do
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

    it 'returns nothing if no change required' do
      allow(product).to receive(:price) { 110 }
      expect(change).to_not have_received(:calculate_change)
      expect(STDOUT).to_not have_received(:puts).with(/Here's your change/)
    end
  end

  describe '#reload_products' do
    let(:inventory) do
      [
        product
      ]
    end

    before(:each) do
      allow(subject).to receive(:loop).and_yield
      allow(STDOUT).to receive(:puts)
      allow(product).to receive(:available?) { true }
      allow(product).to receive(:name) { 'Test' }
      allow(product).to receive(:price) { 100 }
      allow(product).to receive(:restock)
    end
    it 'asks user for item code and quantity to restock the item with and updates product quantities' do
      allow(STDIN).to receive(:gets).and_return('1', '5')
      subject.reload_products
      expect(product).to have_received(:restock).once.with(5)
      expect(STDOUT).to have_received(:puts).with(/Here are the current products/)
      expect(STDOUT).to have_received(:puts).with(/Please enter the code of the item you want to reload/)
      expect(STDOUT).to have_received(:puts).with(/Enter the quantity you are reloading the item by/)
      expect(STDOUT).to have_received(:puts).with(/Restocked/)
    end
    it 'displays an error message if invalid item code is entered' do
      allow(STDIN).to receive(:gets).and_return('99')
      subject.reload_products
      expect(product).to_not have_received(:restock)
      expect(STDOUT).to have_received(:puts).with(/Invalid code selected. Please try again/)
    end
    it 'displays an error message if invalid item quantity is entered' do
      allow(STDIN).to receive(:gets).and_return('1', '0')
      subject.reload_products
      expect(product).to_not have_received(:restock)
      expect(STDOUT).to have_received(:puts).with(/Invalid quantity entered. Must be a valid number above 0/)
    end
  end

  describe '#reload_changes' do
    before(:each) do
      allow(subject).to receive(:loop).and_yield
      allow(STDOUT).to receive(:puts)
      allow(change).to receive(:insert_coin)
    end
    it 'asks user for coin value and quantity to reload it by, updating coin quantities' do
      allow(STDIN).to receive(:gets).and_return('100', '100')
      subject.reload_change
      expect(change).to have_received(:insert_coin).once.with(100, 100)
      expect(STDOUT).to have_received(:puts).with(/Please enter the pence value of coin you wish to reload/)
      expect(STDOUT).to have_received(:puts).with(/Enter the quantity you are reloading the coins by/)
      expect(STDOUT).to have_received(:puts).with(/Coins reloaded/)
    end
    it 'displays an error message if invalid coin value is entered' do
      allow(STDIN).to receive(:gets).and_return('40')
      subject.reload_change
      expect(change).to_not have_received(:insert_coin)
      expect(STDOUT).to have_received(:puts).with(/Invalid coin value selected/)
    end
    it 'displays an error message if invalid coin quantity is entered' do
      allow(STDIN).to receive(:gets).and_return('100', '0')
      subject.reload_change
      expect(change).to_not have_received(:insert_coin)
      expect(STDOUT).to have_received(:puts).with(/Invalid quantity entered/)
    end
  end
end
