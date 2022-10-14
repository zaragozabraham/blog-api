# frozen_string_literal: true

class PostsController < ApplicationController
  rescue_from Exception do |e|
    render json: { error: e.message }, status: :internal_error
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  before_action :set_post, only: %i[show update]

  def index
    @posts = Post.where(published: true)
    render json: @posts.includes(:author), status: :ok
  end

  def show
    render json: @post, status: :ok
  end

  def create
    @post = Post.create!(create_post_params)
    render json: @post, status: :created
  end

  def update
    @post.update!(update_post_params)
    render json: @post, status: :ok
  end

  private

  def create_post_params
    params.require(:post).permit(%i[title content published author_id])
  end

  def update_post_params
    params.require(:post).permit(%i[title content published])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
