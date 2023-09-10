require 'rails_helper'

RSpec.describe 'Market Index Page', :vcr do
  it 'shows the markets and relevant data' do
    VCR.use_cassette('markets', record: :new_episodes) do
      visit markets_path
      puts "Current cassette name: #{VCR.current_cassette.name}"

      expect(page).to have_content('Markets')
    end
  end
end
