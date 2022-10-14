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

  private

  def payload
    JSON.parse(response.body).with_indifferent_access
  end
end
