require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  it { should belong_to :merchant }
  it { should have_many(:items).through(:merchant) }
  it { should have_many(:invoice_items).through(:items) }
  it { should validate_numericality_of(:percentage).only_integer }
  it { should validate_numericality_of(:percentage).is_less_than(100) }
  it { should validate_numericality_of(:percentage).is_greater_than(0) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:percentage) }
  it { should validate_presence_of(:qty_threshold) }
end
