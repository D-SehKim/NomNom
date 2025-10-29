require 'rails_helper'

RSpec.describe User, type: :model do
  # Using FactoryBot
  let(:user) { build(:user) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is invalid without an email" do
      user.email = nil
      expect(user).to_not be_valid
    end

    it "is invalid without a password" do
      user.password = nil
      expect(user).to_not be_valid
    end
  end

  describe "Devise modules" do
    it "responds to :email" do
      expect(user).to respond_to(:email)
    end

    it "responds to :valid_password?" do
      user.save
      expect(user.valid_password?('password')).to be_truthy
    end
  end
end
