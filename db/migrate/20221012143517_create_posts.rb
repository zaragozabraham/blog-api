# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :content
      t.boolean :published
      t.references :author, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
