# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /post' do
    before { get '/post' }

    let(:payload) { JSON.parse(response.body) }

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /post with data in the DB' do
    before { get '/post' }

    let(:posts) { create_list(:post, 10, published: true) }

    let(:payload) { JSON.parse(response.body) }

    it 'returns all the published posts' do
      expect(payload.size).to eq(posts.size)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /post/:id' do
    let(:post) { create(:post) }

    let(:payload) { JSON.parse(response.body) }

    it 'returns a post' do
      get "/post/#{post.id}"
      expect(payload['id']).to eq(post.id)
    end
  end
end
