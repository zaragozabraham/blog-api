# frozen_string_literal: true

class PostsController < ApplicationController
  include Secured

  before_action :authenticate_user!, only: %i[create update]
  before_action :set_post, only: %i[show destroy]

  rescue_from Exception do |e|
    render json: { error: e.message }, status: :internal_error
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: e.message }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def index
    @posts = Post.where(published: true)
    render json: @posts.includes(:author), status: :ok
  end

  def show
    if @post.published? || (Current.user && @post.author_id == Current.user.id)
      render json: @post, status: :ok
    else
      render json: { error: 'Not Found' }, status: :not_found
    end
  end

  def create
    @post = Post.new(create_post_params)
    @post.author_id = Current.user.id
    render json: @post, status: :created if @post.save
  end

  def update
    @post = Current.user.posts.find(params[:id])
    @post.update!(update_post_params)
    render json: @post, status: :ok
  end

  def destroy; end

  private

  def create_post_params
    params.require(:post).permit(%i[title content published])
  end

  def update_post_params
    params.require(:post).permit(%i[title content published])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
