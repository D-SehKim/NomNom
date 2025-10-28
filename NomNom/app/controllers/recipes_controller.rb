require 'httparty'

class RecipesController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:ingredient].present?
      ingredient = URI.encode_www_form_component(params[:ingredient])
      url = "https://www.themealdb.com/api/json/v1/1/filter.php?i=#{ingredient}"
      response = HTTParty.get(url)

      if response.success?
        @meals = response.parsed_response["meals"]
      else
        @meals = []
        flash.now[:alert] = "There was an error fetching recipes. Please try again."
      end
    else
      @meals = []
    end
  end

  def show
    meal_id = params[:id]
    url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{meal_id}"
    response = HTTParty.get(url)

    if response.success?
      data = response.parsed_response["meals"]&.first
      if data
        @meal = data
      else
        redirect_to recipes_path, alert: "Recipe not found."
      end
    else
      redirect_to recipes_path, alert: "Error fetching recipe details."
    end
  end
end
