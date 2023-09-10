require 'rails_helper'

RSpec.describe 'Landing Page' do
  it 'Has a title and links' do
    visit root_path
    expect(page).to have_content('Market Money')
    expect(page).to have_link('Home')
    expect(page).to have_link('Markets')
  end
end
