require 'rails_helper'

RSpec.describe 'Vendor Show Page', :vcr do
  # Happy Path
  it 'shows the vendor attributes' do
    VCR.use_cassette('vendor_show', record: :new_episodes) do
      visit vendor_path(55_823)
      expect(page).to have_content('Name: Claudie Langworth III')
      expect(page).to have_content('Phone: 1-147-179-9747')
      expect(page).to have_content('Accepts Credit: No')
      expect(page).to have_content('Description: Vendor selling a variety of artisanal cured meats and sausages.')
    end
  end
end

# Sad Path
RSpec.describe 'Vendor Show Page' do
  it 'renders an error message for malformed API response' do
    stub_request(:get, 'http://localhost:3000/api/v0/vendors/1')
      .to_return(status: 200, body: '{"malformed": "response"}', headers: {})

    visit vendor_path(1)
    expect(page).to have_content('Malformed API response')
  end

  it 'renders an error message when unable to fetch vendor data' do
    stub_request(:get, 'http://localhost:3000/api/v0/vendors/1')
      .to_return(status: 404, body: '{}', headers: {})

    visit vendor_path(1)

    expect(page).to have_content('Unable to fetch vendor data')
  end
end
