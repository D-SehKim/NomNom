require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'associations' do
    it { should have_many(:grocery_items).dependent(:destroy) }
    it { should have_many(:user_meals).dependent(:destroy) }
    it { should have_many(:recipes).through(:user_meals) }
  end

  describe 'Devise modules' do
    it 'includes database_authenticatable module' do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it 'includes registerable module' do
      expect(User.devise_modules).to include(:registerable)
    end

    it 'includes recoverable module' do
      expect(User.devise_modules).to include(:recoverable)
    end

    it 'includes rememberable module' do
      expect(User.devise_modules).to include(:rememberable)
    end

    it 'includes validatable module' do
      expect(User.devise_modules).to include(:validatable)
    end
  end

  describe 'email validation' do
    it 'accepts valid email formats' do
      valid_emails = %w[
        user@example.com
        test.user@example.org
        user+tag@example.co.uk
        firstname-lastname@example.com
      ]

      valid_emails.each do |email|
        user = build(:user, email: email)
        expect(user).to be_valid, "#{email} should be valid"
      end
    end

    it 'rejects invalid email formats' do
      invalid_emails = %w[
        user@
        @example.com
        not_an_email
        @.com
      ]

      invalid_emails.each do |email|
        user = build(:user, email: email)
        expect(user).not_to be_valid, "#{email} should be invalid"
      end
    end
  end

  describe 'password validation' do
    it 'requires password confirmation to match' do
      user = build(:user, password: 'password123', password_confirmation: 'different')
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it 'accepts valid password with confirmation' do
      user = build(:user, password: 'password123', password_confirmation: 'password123')
      expect(user).to be_valid
    end
  end

  describe 'factory' do
    it 'creates a valid user' do
      user = create(:user)
      expect(user).to be_valid
      expect(user).to be_persisted
    end

    it 'creates user with unique email' do
      user1 = create(:user)
      user2 = build(:user, email: user1.email)
      expect(user2).not_to be_valid
      expect(user2.errors[:email]).to include('has already been taken')
    end
  end

  describe 'grocery_items association' do
    let(:user) { create(:user) }

    it 'can have multiple grocery items' do
      grocery_item1 = create(:grocery_item, user: user)
      grocery_item2 = create(:grocery_item, user: user)
      
      expect(user.grocery_items).to include(grocery_item1, grocery_item2)
    end

    it 'destroys associated grocery items when user is destroyed' do
      grocery_item = create(:grocery_item, user: user)
      user_id = user.id
      
      user.destroy
      
      expect(GroceryItem.find_by(id: grocery_item.id)).to be_nil
    end
  end

  describe 'Devise authentication' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    it 'can find user by email' do
      found_user = User.find_for_authentication(email: 'test@example.com')
      expect(found_user).to eq(user)
    end

    it 'returns nil for incorrect email' do
      expect(User.find_for_authentication(email: 'wrong@example.com')).to be_nil
    end

    it 'validates password correctly' do
      expect(user.valid_password?('password123')).to be true
      expect(user.valid_password?('wrongpassword')).to be false
    end
  end
end
