require_relative "../lib/product"

RSpec.describe Product do
  subject { described_class.new('Crisps', 60, 1)}
  describe "#initialize" do
    it "has a name" do
      expect(subject.name).to eq('Crisps')
    end

    it "has a price" do
      expect(subject.price).to eq(60)
    end

    it "has a quantity" do
      expect(subject.quantity).to eq(1)
    end

    it "is implicitly initialised with a quantity of one" do
      another_product = described_class.new('Coke', 60)
      expect(another_product.quantity).to eq(1)
    end
  end
end