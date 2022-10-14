# frozen_string_literal: true

class User < ApplicationRecord
  has_many :posts, foreign_key: :author, dependent: :destroy, inverse_of: :author

  validates :email, :name, presence: true

  after_initialize :gen_auth_token

  def gen_auth_token
    self.auth_token ||= TokenGenerationService.generate
  end
end
