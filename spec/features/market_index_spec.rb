require 'rails_helper'

# Happy Path
RSpec.describe 'Market Index Page', :vcr do
  it 'shows the markets and relevant data' do
    VCR.use_cassette('markets', record: :new_episodes) do
      visit markets_path

      within 'table thead' do
        expect(page).to have_selector('th', text: 'Name')
        expect(page).to have_selector('th', text: 'City')
        expect(page).to have_selector('th', text: 'State')
      end

      within 'table tbody tr:first-child' do
        expect(page).to have_content('14&U Farmers\' Market')
        expect(page).to have_content('Washington')
        expect(page).to have_content('District of Columbia')
      end
    end
  end

  it 'has a link to the market show page' do
    VCR.use_cassette('markets', record: :new_episodes) do
      visit markets_path
      within 'table tbody tr:first-child' do
        expect(page).to have_selector("form[action$='/markets/322458']")
      end
    end
  end
end

# Sad Path
RSpec.feature 'Market Index Page', type: :feature do
  it 'shows an error message on non-200 status code' do
    WebMock.stub_request(:get, 'http://localhost:3000/api/v0/markets')
           .to_return(status: 404, body: '', headers: {})

    VCR.use_cassette('market_index_non_200', record: :new_episodes) do
      visit markets_path

      expect(page).to have_content('Unable to fetch markets')
    end
  end
end
