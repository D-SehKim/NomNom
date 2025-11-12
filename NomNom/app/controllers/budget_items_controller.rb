class BudgetItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_budget_item, only: %i[edit update destroy]

  def index
    @budget_items = current_user.budget_items.recent
    @total_spent = @budget_items.sum(:amount)
  end

  def new
    @budget_item = current_user.budget_items.new
  end

  def edit; end

  def create
    @budget_item = current_user.budget_items.new(budget_item_params)
    if @budget_item.save
      redirect_to budget_items_path, notice: "Budget item added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @budget_item.update(budget_item_params)
      redirect_to budget_items_path, notice: "Budget item updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @budget_item.destroy
    redirect_to budget_items_path, notice: "Budget item removed."
  end

  private

  def set_budget_item
    @budget_item = current_user.budget_items.find(params[:id])
  end

  def budget_item_params
    params.require(:budget_item).permit(:name, :amount, :notes)
  end
end
