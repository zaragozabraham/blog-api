# frozen_string_literal: true

class User < ApplicationRecord
  has_many :posts, foreign_key: :author, dependent: :destroy, inverse_of: :author

  validates :email, :name, :auth_token, presence: true
end
