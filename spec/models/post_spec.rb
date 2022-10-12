# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  subject(:post) { described_class.new }

  describe 'validation of required fields' do
    it 'validates presence of title' do
      expect(post).to validate_presence_of(:title)
    end

    it 'validates presence of content' do
      expect(post).to validate_presence_of(:content)
    end

    it 'validates presence of published' do
      expect(post).to validate_inclusion_of(:published).in_array([true, false])
    end

    it 'validates presence of user_id' do
      expect(post).to validate_presence_of(:user_id)
    end
  end
end
