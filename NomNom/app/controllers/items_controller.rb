class ItemsController < ApplicationController
  before_action :authenticate_user!  # Require login

  def index
    @items = Item.order(created_at: :desc)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to items_path, notice: "Item added successfully."
    else
      render :new
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :expires_at)
  end
end
