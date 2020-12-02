require_relative '../lib/change_holder'

RSpec.describe ChangeHolder do
  let(:coins) do
    {
      200 => 20,
      100 => 20,
      50 => 20,
      20 => 20,
      10 => 20,
      5 => 20,
      2 => 20,
      1 => 20
    }
  end
  subject { described_class.new(coins) }

  describe '#initialize' do
    it 'has coins property which is a hash of key/value pairs of coins pence value and quantity' do
      expect(subject.coins).to be_a(Hash)
      expect(subject.coins).to eq(coins)
    end
  end

  describe '#insert_coin' do
    it 'increments the desired coin value by a given amount' do
      expect { subject.insert_coin(200, 20) }.to change { subject.coins[200] }.by(20)
      expect(subject.coins[200]).to eq(40)
    end

    it 'increments the desired coin value by 1 if amount is omitted' do
      expect { subject.insert_coin(200) }.to change { subject.coins[200] }.by(1)
      expect(subject.coins[200]).to eq(21)
    end

    it 'raises an error if an invalid coin value is provided' do
      expect { subject.insert_coin(140) }.to raise_error(VendingMachineExceptions::InvalidCoinError, /Invalid coin provided/)
    end
  end

  describe '#return_coin' do
    it 'returns array of returned coin values' do
      expect(subject.return_coin(100, 3)).to eq([100, 100, 100])
      expect(subject.return_coin(200)).to eq([200])
    end
    it 'decrements the desired coin value by a given amount' do
      expect { subject.return_coin(100, 3) }.to change { subject.coins[100] }.by(-3)
      expect(subject.coins[100]).to eq(17)
    end

    it 'decrements the desired coin value by 1 if amount is omitted' do
      expect { subject.return_coin(100) }.to change { subject.coins[100] }.by(-1)
      expect(subject.coins[100]).to eq(19)
    end

    it 'raises an error if an invalid coin value is provided' do
      expect { subject.insert_coin(140) }.to raise_error(VendingMachineExceptions::InvalidCoinError, /Invalid coin provided/)
    end

    it 'raises an error if the amount of coins requested cannot be returned' do
      expect { subject.return_coin(50, 100) }.to raise_error(VendingMachineExceptions::CoinReturnError, /Cannot return the requested amount of coins/)
    end
  end

  describe '#calculate_change' do
    it 'removes returned coins from the coin holder' do
      allow(subject).to receive(:return_coin)
      subject.calculate_change(140, 200)
      expect(subject).to have_received(:return_coin).once.with(50)
      expect(subject).to have_received(:return_coin).once.with(10)
    end
    it 'returns a change as an array of coin values with highest possible denominations' do
      expect(subject.calculate_change(140, 200)).to eq([50, 10])
    end
    it 'it returns array of coins with lower denominations if higher denominations cannot be found' do
      coins = {
        200 => 20,
        100 => 20,
        50 => 0,
        20 => 5,
        10 => 0,
        5 => 1,
        2 => 5,
        1 => 5
      }
      another_subject = described_class.new(coins)

      expect(another_subject.calculate_change(150, 200)).to eq([20, 20, 5, 2, 2, 1])
    end

    it 'raises an error if needed change cannot be dispensed' do
      coins = {
        200 => 20,
        100 => 20,
        50 => 0,
        20 => 0,
        10 => 0,
        5 => 1,
        2 => 0,
        1 => 5
      }

      another_subject = described_class.new(coins)

      expect { another_subject.calculate_change(150, 200) }.to raise_error(VendingMachineExceptions::NotEnoughChange, /Cannot dispense required amount of change/)
    end
  end
end
