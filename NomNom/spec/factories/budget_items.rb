FactoryBot.define do
  factory :budget_item do
    association :user
    sequence(:name) { |n| "Budget Item #{n}" }
    amount { 12.50 }
    notes { 'Weekly groceries' }
  end
end
