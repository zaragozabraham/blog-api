# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { described_class.new }

  describe 'validation of required fields' do
    it 'validates presence of name' do
      expect(user).to validate_presence_of(:name)
    end

    it 'validates presence of email' do
      expect(user).to validate_presence_of(:email)
    end

    it 'validates presence of auth_token' do
      expect(user).to validate_presence_of(:auth_token)
    end

    it 'validate relations' do
      expect(user).to have_many(:posts)
    end
  end
end
