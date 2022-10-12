# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validation of required fields' do
    it 'validates presence of title' do
      should validate_presence_of(:title)
    end

    it 'validates presence of content' do
      should validate_presence_of(:content)
    end

    it 'validates presence of published' do
      should validate_presence_of(:published)
    end

    it 'validates presence of user_id' do
      should validate_presence_of(:user_id)
    end
  end
end
