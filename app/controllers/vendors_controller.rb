class VendorsController < ApplicationController
  include HTTParty
  base_uri 'http://localhost:3000/api/v0'

  def show
    response = self.class.get("/vendors/#{params[:id]}")
    if response.code == 200
      raw_vendor = JSON.parse(response.body)
      if raw_vendor && raw_vendor['data'] && raw_vendor['data']['attributes']
        @vendor = raw_vendor['data']['attributes'].merge('id' => raw_vendor['data']['id'])
      else
        render status: :unprocessable_entity, json: { error: 'Malformed API response' }
      end
    else
      render status: response.code, json: { error: 'Unable to fetch vendor data' }
    end
  end
end
