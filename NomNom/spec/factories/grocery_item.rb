FactoryBot.define do
  factory :grocery_item do
    name { "Test Item" }
    quantity { "1" }
    purchased { false }
    notes { "Test notes" }
    association :user
  end

  trait :purchased do
    purchased { true }
  end

  trait :not_purchased do
    purchased { false }
  end

  trait :with_notes do
    notes { "Remember to get the organic version" }
  end

  trait :without_notes do
    notes { nil }
  end
end
