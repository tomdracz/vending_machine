require_relative "../lib/product"

RSpec.describe Product do
  subject { described_class.new('Crisps', 60, 1) }
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

  describe "#restock" do
    it "can be restocked by a given quantity" do
      expect { subject.restock(2) }.to change { subject.quantity }.by(2)
      expect(subject.quantity).to eq(3)
    end

    it "is restocked by 1 if quantity is omitted" do
      expect { subject.restock }.to change { subject.quantity }.by(1)
      expect(subject.quantity).to eq(2)
    end
  end

  describe "#remove" do
    let(:another_product) { described_class.new('Coke', 60, 5) }
    it "allows for given quantity of product to be removed" do
      expect { another_product.remove(2) }.to change { another_product.quantity }.by(-2)
      expect(another_product.quantity).to eq(3)
    end

    it "removes one product from quantity if quantity is omitted" do
      expect { another_product.remove }.to change { another_product.quantity }.by(-1)
      expect(another_product.quantity).to eq(4)
    end

    it "prevents removal of more products than current quantity available" do
      expect { another_product.remove(6) }.to raise_error(/Cannot remove more products then available/)
      expect(another_product.quantity).to eq(5)
    end
  end

  describe "#available?" do
    let(:another_product) { described_class.new('Coke', 60, 5) }
    it "returns true if quantity of product is above 0" do
      another_product.remove(4)
      expect(another_product.available?).to be true
    end

    it "returns false if quantity of product is 0" do
      another_product.remove(5)
      expect(another_product.available?).to be false
    end
  end
end