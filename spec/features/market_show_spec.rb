require 'rails_helper'

RSpec.describe 'Market Show Page', :vcr do
  # Happy Path
  it 'shows the market attributes and vendors at that market ' do
    VCR.use_cassette('market', record: :new_episodes) do
      visit market_path(322_458)
      expect(page).to have_content('14&U Farmers\' Market')
      expect(page).to have_content('Washington')
      expect(page).to have_content('District of Columbia')
      expect(page).to have_content('Vendors at our Market:')
      expect(page).to have_content('The Charcuterie Corner')
    end
  end

  it 'has a link to the vendor show page' do
    VCR.use_cassette('market', record: :new_episodes) do
      visit market_path(322_458)
      expect(page).to have_link('The Charcuterie Corner')
    end
  end

  # Sad Path
  it 'shows an error message on non-200 status code' do
    VCR.use_cassette('market_show_non_200', record: :new_episodes) do
      visit market_path('invalid-id')

      expect(page).to have_content('{"error":"Unable to fetch vendors"}')
    end
  end

  it 'assigns @markets as empty array and displays appropriate message' do
    stub_request(:get, 'http://localhost:3000/api/v0/markets')
      .to_return(status: 200, body: '{"data": null}', headers: {})

    visit markets_path
    expect(page).not_to have_css('.market')
  end

  it 'renders an error message when the API returns malformed data' do
    stub_request(:get, 'http://localhost:3000/api/v0/markets/1')
      .to_return(status: 200, body: '{}', headers: {})

    visit market_path(1)
    expect(page).to have_content('Malformed API response')
  end

  it 'assigns @vendors as an empty array when API returns malformed data' do
    stub_request(:get, 'http://localhost:3000/api/v0/markets/1')
      .to_return(status: 200, body: '{"data": {"attributes": {"name": "Some Market", "location": "Some Location"}, "id": "1"}}', headers: {})

    stub_request(:get, 'http://localhost:3000/api/v0/markets/1/vendors')
      .to_return(status: 200, body: '{"malformed": "data"}', headers: {})

    visit market_path(1)

    expect(page).not_to have_selector('.vendor-item')
  end
end
