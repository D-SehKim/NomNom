FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password123" }
    password_confirmation { "password123" }
    
    trait :with_grocery_items do
      after(:create) do |user|
        create_list(:grocery_item, 3, user: user)
      end
    end
  end
end