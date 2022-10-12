# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'

  validates :title, :content, :author_id, presence: true
  validates :published, inclusion: { in: [true, false] }
end
