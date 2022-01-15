require 'rails_helper'

RSpec.describe "Merchant Bulk Discounts Index page", type: :feature do 
  
  it "has each bulk discount along with its percentage and quantity specifications" do 

    within ".bulk-discount-#{@bulk_discount_1.id}" do
      expect(page).to have_content("Bulk Discount, ID: #{@bulk_discount_1.id}")
      expect(page).to have_content("Percentage: #{@bulk_discount_1.percentage}")
      expect(page).to have_content("Quantity: #{@bulk_discount_1.quantity}")
    end

    within ".bulk-discount-#{@bulk_discount_2.id}" do
      expect(page).to have_content("Bulk Discount, ID: #{@bulk_discount_2.id}")
      expect(page).to have_content("Percentage: #{@bulk_discount_2.percentage}")
      expect(page).to have_content("Quantity: #{@bulk_discount_2.quantity}")
    end
  end

  xit "each discount has its respective percentage and quantity thresholds and links to its bulk discount show page" do 
  end

end
