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
end
