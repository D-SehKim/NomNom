class GroceryItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_grocery_item, only: [:edit, :update, :destroy, :toggle_purchased]

  def index
    @grocery_items = current_user.grocery_items.recent
    @not_purchased = @grocery_items.not_purchased
    @purchased = @grocery_items.purchased
  end

  def new
    @grocery_item = GroceryItem.new
  end

  def create
    @grocery_item = current_user.grocery_items.build(grocery_item_params)
    if @grocery_item.save
      redirect_to grocery_items_path, notice: "Item added to grocery list successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @grocery_item.update(grocery_item_params)
      redirect_to grocery_items_path, notice: "Item updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @grocery_item.destroy
    redirect_to grocery_items_path, notice: "Item removed from grocery list."
  end

  def toggle_purchased
    @grocery_item.update(purchased: !@grocery_item.purchased)
    redirect_to grocery_items_path
  end

  private

  def set_grocery_item
    @grocery_item = current_user.grocery_items.find(params[:id])
  end

  def grocery_item_params
    params.require(:grocery_item).permit(:name, :quantity, :purchased, :notes)
  end
end
