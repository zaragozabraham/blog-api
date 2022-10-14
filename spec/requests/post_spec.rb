# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /posts' do
    before { get '/posts' }

    let(:payload) { JSON.parse(response.body) }

    it 'returns status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /posts with data in the DB' do
    let!(:posts) { create_list(:post, 10, published: true) }
    let(:payload) { JSON.parse(response.body) }

    before { get '/posts' }

    it 'returns all the published posts' do
      expect(payload.size).to eq(posts.size)
    end

    it 'returns status code 200' do
      p payload.size
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /posts/:id' do
    let(:user) { create(:user) }
    let(:post) { create(:post, author_id: user.id) }
    let(:payload) { JSON.parse(response.body) }

    it 'returns a post with id' do
      get "/posts/#{post.id}"
      expect(payload['id']).to eq(post.id)
    end

    it 'returns a post with title' do
      get "/posts/#{post.id}"
      expect(payload['title']).to eq(post.title)
    end

    it 'returns a post with content' do
      get "/posts/#{post.id}"
      expect(payload['content']).to eq(post.content)
    end

    it 'returns a post with user name' do
      get "/posts/#{post.id}"
      expect(payload['author']['name']).to eq(user.name)
    end

    it 'returns a post with user email' do
      get "/posts/#{post.id}"
      expect(payload['author']['email']).to eq(user.email)
    end

    it 'returns a post with user id' do
      get "/posts/#{post.id}"
      expect(payload['author']['id']).to eq(user.id)
    end
  end

  describe 'Search | Get /posts' do
    let!(:post1) { create(:published_post, title: 'Hello World') }
    let!(:post2) { create(:published_post, title: 'Welcome to Rails') }
    let(:post3) { create(:published_post, title: 'API with Ruby on Rails') }
    let(:payload) { JSON.parse(response.body) }

    before { get '/posts?search=Rails' }

    it 'filters posts by title' do
      expect(payload).not_to be_empty
    end

    it 'returns two posts' do
      expect(payload.size).to eq(2)
    end

    it "returns the two post that contain 'Rails' in the title" do
      expect(payload.map { |p| p['id'] }.sort).to eq([post1.id, post2.id])
    end
  end

  describe 'POST /posts' do
    let!(:user) { create(:user) }
    let(:payload) { JSON.parse(response.body) }
    let(:req_payload) do
      { post: {
        title: 'some title',
        content: 'some content of the post',
        published: false,
        author_id: user.id
      } }
    end

    before { post '/posts', params: req_payload }

    it 'creates a post' do
      expect(payload['id']).not_to be_nil
    end

    it 'creates a post and returns status created' do
      expect(response).to have_http_status(:created)
    end
  end

  describe 'POST /posts with invalid post' do
    let!(:user) { create(:user) }
    let(:payload) { JSON.parse(response.body) }
    let(:req_payload) do
      { post: {
        content: 'some content of the post',
        published: false,
        author_id: user.id
      } }
    end

    before { post '/posts', params: req_payload }

    it 'returns error message on invalid post' do
      expect(payload['error']).not_to be_empty
    end

    it 'returns returns unprocessable entity status code' do
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /posts/:id' do
    let!(:article) { create(:post) }
    let(:payload) { JSON.parse(response.body) }
    let(:req_payload) do
      { post: {
        title: 'some title',
        published: false
      } }
    end

    before { put "/posts/#{article.id}", params: req_payload }

    it 'creates a post, updates it and return status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it "creates a post and updates its title to 'some title'" do
      expect(payload['title']).to eq('some title')
    end
  end
end
