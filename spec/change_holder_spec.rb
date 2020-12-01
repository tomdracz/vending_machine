require_relative "../lib/change_holder"

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
      expect { subject.insert_coin(140) }.to raise_error(/Invalid coin provided/)
    end
  end

  describe '#return_coin' do
    it 'returns array of returned coin values' do
      expect(subject.return_coin(100, 3)).to eq([100, 100, 100])
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
      expect { subject.insert_coin(140) }.to raise_error(/Invalid coin provided/)
    end

    it 'raises an error if the amount of coins requested cannot be returned' do
      expect { subject.return_coin(50, 100) }.to raise_error(/Cannot return the requested amount of coins/)
    end
  end
end
