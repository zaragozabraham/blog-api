# frozen_string_literal: true

class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :published
  belongs_to :author

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :name, :email
  end
end
