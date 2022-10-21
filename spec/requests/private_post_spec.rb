# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /posts/:id with authentication', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:other_user_post) { create(:post, author_id: other_user.id, published: true) }
  let!(:other_user_post_draft) { create(:post, author_id: other_user.id, published: false) }
  let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }

  context "when requisting other's author post with valid auth" do
    context 'when post is public' do
      before { get "/posts/#{other_user_post.id}", headers: auth_headers }

      it { expect(payload).to include(:id) }
      it { expect(response).to have_http_status(:ok) }
    end

    context 'when post is draft' do
      before { get "/posts/#{other_user_post_draft.id}", headers: auth_headers }

      it { expect(payload).to include(:error) }
      it { expect(response).to have_http_status(:not_found) }
    end
  end

  context 'when doing POST /posts' do
    let!(:create_params) { { post: { title: 'title', content: 'content', published: true } } }

    context 'with valid auth' do
      before { post '/posts', params: create_params, headers: auth_headers }

      it { expect(payload).to include(:id) }
      it { expect(response).to have_http_status(:created) }
    end

    context 'with invalid auth' do
      before { post '/posts', params: create_params }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  context 'when doing PUT /posts' do
    let!(:user_post) { create(:post, author_id: user.id, published: true) }
    let!(:update_params) { { post: { title: 'Updated title', content: 'Updated content' } } }

    context "with valid auth and user's post" do
      before { put "/posts/#{user_post.id}", params: update_params, headers: auth_headers }

      it { expect(payload['title']).to match('Updated title') }
      it { expect(payload['content']).to match('Updated content') }
      it { expect(response).to have_http_status(:ok) }
    end

    context "with valid auth and another user's post" do
      before { put "/posts/#{other_user_post.id}", params: update_params, headers: auth_headers }

      it { expect(response).to have_http_status(:not_found) }
    end

    context "with invalid auth and user's post" do
      before { put "/posts/#{user_post.id}", params: update_params }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context "with invalid auth and another user's post" do
      before { put "/posts/#{other_user_post.id}", params: update_params }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  private

  def payload
    JSON.parse(response.body).with_indifferent_access
  end
end
