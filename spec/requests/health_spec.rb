# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Health endoint', type: :request do
  describe 'GET /health' do
    before { get '/health' }

    let(:payload) { JSON.parse(response.body) }

    it 'is supposed to not return nil/empty' do
      expect(payload).not_to be_empty
    end

    it 'is supposed to return OK' do
      expect(payload['api']).to eq('OK')
    end

    it 'is supposed to return status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end
end
