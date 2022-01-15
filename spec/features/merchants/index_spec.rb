require 'rails_helper'

RSpec.describe "Merchant Index page" do
  it 'links to merchant show page' do
    merchant1 = Merchant.create!(name: 'merchant1')

    visit "/merchants/"

    expect(page).to have_content(merchant1.name)
    click_link "#{merchant1.name}"
    expect(current_path).to eq("/merchants/#{merchant1.id}/dashboard")
  end
end
