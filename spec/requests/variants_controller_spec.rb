require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :request do
  let(:user) { create(:user) }
  let(:account) { user.account }
  let(:product) { create(:product, account: account) }
  let(:variant) { product.default_variant }
  let(:access_key) { user.access_keys.first }

  let(:headers) do
    token = access_key.token
    auth_token = access_key.auth_token
    { 'HTTP_AUTHORIZATION': basic_auth(token, auth_token) }
  end

  before { product }

  describe 'GET /api/v1/products/:product_id/variants' do
    it 'returns list of variants' do
      get "/api/v1/products/#{product.id}/variants", headers: headers
      expect(json['variants'].count).to eq(1)
      expect(json).to include_json(variants: [])
    end
  end

  describe 'GET /api/v1/products/:product_id/variants/count' do
    it 'counts product variants' do
      get "/api/v1/products/#{product.id}/variants/count", headers: headers
      expect(json).to include_json(count: 1)
    end
  end

  describe 'GET /api/v1/variants' do
    it 'returns list of variants' do
      get '/api/v1/variants', headers: headers
      expect(json['variants'].count).to eq(1)
      expect(json).to include_json(variants: [])
    end
  end

  describe 'GET /api/v1/variants/count' do
    it 'counts variants' do
      get '/api/v1/variants/count', headers: headers
      expect(json).to include_json(count: 1)
    end
  end

  describe 'GET /api/v1/variants/:id' do
    context 'with existing variant' do
      it 'returns the variant' do
        get "/api/v1/variants/#{variant.id}", headers: headers
        expect(json).to include_json(variant: {})
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with a non-existent variant' do
      it 'returns the 404' do
        get '/api/v1/variants/0', headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
