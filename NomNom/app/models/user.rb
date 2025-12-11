class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :user_meals, dependent: :destroy
  has_many :recipes, through: :user_meals
  has_many :grocery_items, dependent: :destroy
  has_many :budget_items, dependent: :destroy
  has_many :items, dependent: :destroy
end
