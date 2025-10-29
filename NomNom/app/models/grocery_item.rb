class GroceryItem < ApplicationRecord
  belongs_to :user
  
  validates :name, presence: true
  validates :quantity, presence: true
  
  scope :purchased, -> { where(purchased: true) }
  scope :not_purchased, -> { where(purchased: false) }
  scope :recent, -> { order(created_at: :desc) }
end
