# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation of required fields' do
    it 'validates presence of name' do
      should validate_presence_of(:name)
    end

    it 'validates presence of email' do
      should validate_presence_of(:email)
    end

    it 'validates presence of auth_token' do
      should validate_presence_of(:auth_token)
    end

    it 'validate relations' do
      should have_many(:posts)
    end
  end
end
