RSpec.describe Spree::Product, type: :model do
  let(:product) { create(:product) }
  let(:taxon)   { create(:taxon) }

  # Regression test for #309
  it 'duplicates translations' do
    original_count = product.translations.count
    new_product = product.duplicate
    expect(new_product.translations).not_to be_blank
    expect(product.translations.count).to be(original_count)
  end

  # Regression test for #433
  it 'allow saving a product with taxons' do
    product.taxons << taxon
    expect(product.taxons).to include(taxon)
  end

  context "soft-deletion" do
    subject do
      product.destroy
      product.reload
    end

    it "keeps the translation on deletion" do
      subject
      expect(product.translations).not_to be_empty
    end

    it "changes the slug on the translation to allow reuse of original slug" do
      expect do
        subject
      end.to change { product.slug }
    end
  end
end
