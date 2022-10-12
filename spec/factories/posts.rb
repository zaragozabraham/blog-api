# frozen_string_literal: true

FactoryBot.use_parent_strategy = false

FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published { [true, false].sample }
    author factory: :user
  end
end
