class MarketsController < ApplicationController
  include HTTParty
  base_uri 'http://localhost:3000/api/v0'

  # MarketsController
  def index
    response = self.class.get('/markets')

    if response.code == 200
      raw_markets = JSON.parse(response.body)
      @markets = if raw_markets['data']
                   raw_markets['data'].map do |market_data|
                     market_data['attributes'].merge('id' => market_data['id'])
                   end
                 else
                   []
                 end
    else
      @error_message = 'Unable to fetch markets'
    end
  end

  def show
    response = self.class.get("/markets/#{params[:id]}")

    if response.code == 200
      raw_market = JSON.parse(response.body)
      if raw_market && raw_market['data'] && raw_market['data']['attributes']
        @market = raw_market['data']['attributes'].merge('id' => raw_market['data']['id'])
      else
        render status: :unprocessable_entity, json: { error: 'Malformed API response' }
        return
      end
    end

    # Fetch vendors for the market
    vendors_response = self.class.get("/markets/#{params[:id]}/vendors")

    if vendors_response.code == 200
      raw_vendors = JSON.parse(vendors_response.body)
      @vendors = if raw_vendors && raw_vendors['data']
                   raw_vendors['data'].map do |vendor_data|
                     vendor_data['attributes'].merge('id' => vendor_data['id'])
                   end
                 else
                   []
                 end
    else
      # Handle other HTTP error codes from API
      render status: vendors_response.code, json: { error: 'Unable to fetch vendors' }
      nil
    end
  end
end
