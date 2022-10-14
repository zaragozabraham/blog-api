# frozen_string_literal: true

RSpec.describe 'Posts with authentication' do
  describe "GET /posts/:id requesting othe's author posts" do
    let!(:user) { create(:user) }
    let!(:user2) { create(:user) }
    let(:user_post) { create(:published_post, author_id: user.id) }
    let!(:user2_post) { create(:published_post, author_id: user2.id) }
    let!(:user2_post_draft) { create(:post, author_id: user2.id, published: false) }
    let!(:auth_headers) { 'Authorization' => "Bearer #{user.auth_token}" }
    let(:auth_headers2) { 'Authorization' => "Bearer #{user2.auth_token}" }

    context 'when post is public' do
      before { get "/posts/#{user2_post.id}", headers: auth_headers }

      let(:payload) { JSON.parse(response.body) }

      it 'has the post id at response' do
        expect(payload).to include(:id)
      end

      it 'has a status code Not Found' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when post is a draft' do
      before { get "/posts/#{user2_post_draft.id}", headers: auth_headers }

      let(:payload) { JSON.parse(response.body) }

      it 'has error at response' do
        expect(payload).to include(:error)
      end

      it 'has a status code Not Found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
