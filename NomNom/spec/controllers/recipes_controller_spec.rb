require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  let(:user) { create(:user) }

  describe "authentication" do
    it "redirects to login when user is not authenticated" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when user is authenticated" do
    before { sign_in user }

    describe "GET #index" do
      context "without ingredient parameter" do
        it "returns a success response" do
          get :index
          expect(response).to be_successful
        end

        it "assigns an empty array to @meals" do
          get :index
          expect(assigns(:meals)).to eq([])
        end
      end

      context "with ingredient parameter" do
        let(:mock_response) do
          {
            "meals" => [
              {
                "strMeal" => "Chicken Curry",
                "strMealThumb" => "https://example.com/image.jpg",
                "idMeal" => "52796"
              },
              {
                "strMeal" => "Chicken Soup",
                "strMealThumb" => "https://example.com/image2.jpg",
                "idMeal" => "52797"
              }
            ]
          }
        end

        before do
          allow(HTTParty).to receive(:get).and_return(
            double(success?: true, parsed_response: mock_response)
          )
        end

        it "makes a request to the MealDB API with encoded ingredient" do
          expect(HTTParty).to receive(:get)
            .with("https://www.themealdb.com/api/json/v1/1/filter.php?i=chicken")
            .and_return(double(success?: true, parsed_response: mock_response))
          
          get :index, params: { ingredient: "chicken" }
        end

        it "encodes special characters in ingredient parameter" do
          expect(HTTParty).to receive(:get)
            .with("https://www.themealdb.com/api/json/v1/1/filter.php?i=chicken+breast")
            .and_return(double(success?: true, parsed_response: mock_response))
          
          get :index, params: { ingredient: "chicken breast" }
        end

        it "assigns the meals from the API response" do
          get :index, params: { ingredient: "chicken" }
          expect(assigns(:meals)).to eq(mock_response["meals"])
        end

        it "returns a success response" do
          get :index, params: { ingredient: "chicken" }
          expect(response).to be_successful
        end
      end

      context "when API request fails" do
        before do
          allow(HTTParty).to receive(:get).and_return(
            double(success?: false, parsed_response: {})
          )
        end

        it "assigns an empty array to @meals" do
          get :index, params: { ingredient: "chicken" }
          expect(assigns(:meals)).to eq([])
        end

        it "sets an error flash message" do
          get :index, params: { ingredient: "chicken" }
          expect(flash.now[:alert]).to eq("There was an error fetching recipes. Please try again.")
        end

        it "still returns a success response" do
          get :index, params: { ingredient: "chicken" }
          expect(response).to be_successful
        end
      end

      context "when API returns null meals" do
        before do
          allow(HTTParty).to receive(:get).and_return(
            double(success?: true, parsed_response: { "meals" => nil })
          )
        end

        it "assigns nil to @meals" do
          get :index, params: { ingredient: "nonexistent" }
          expect(assigns(:meals)).to be_nil
        end
      end
    end

    describe "GET #show" do
      let(:meal_id) { "52796" }
      let(:mock_meal_data) do
        {
          "meals" => [
            {
              "idMeal" => "52796",
              "strMeal" => "Chicken Curry",
              "strCategory" => "Chicken",
              "strInstructions" => "Cook the chicken...",
              "strMealThumb" => "https://example.com/image.jpg"
            }
          ]
        }
      end

      context "when recipe is found" do
        before do
          allow(HTTParty).to receive(:get).and_return(
            double(success?: true, parsed_response: mock_meal_data)
          )
        end

        it "makes a request to the MealDB API with the meal ID" do
          expect(HTTParty).to receive(:get)
            .with("https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{meal_id}")
            .and_return(double(success?: true, parsed_response: mock_meal_data))
          
          get :show, params: { id: meal_id }
        end

        it "assigns the meal data to @meal" do
          get :show, params: { id: meal_id }
          expect(assigns(:meal)).to eq(mock_meal_data["meals"].first)
        end

        it "returns a success response" do
          get :show, params: { id: meal_id }
          expect(response).to be_successful
        end
      end

      context "when API request fails" do
        before do
          allow(HTTParty).to receive(:get).and_return(
            double(success?: false, parsed_response: {})
          )
        end

        it "redirects to recipes path" do
          get :show, params: { id: meal_id }
          expect(response).to redirect_to(recipes_path)
        end

        it "sets an error alert message" do
          get :show, params: { id: meal_id }
          expect(flash[:alert]).to eq("Error fetching recipe details.")
        end
      end

      context "when recipe is not found" do
        before do
          allow(HTTParty).to receive(:get).and_return(
            double(success?: true, parsed_response: { "meals" => nil })
          )
        end

        it "redirects to recipes path" do
          get :show, params: { id: "invalid_id" }
          expect(response).to redirect_to(recipes_path)
        end

        it "sets a not found alert message" do
          get :show, params: { id: "invalid_id" }
          expect(flash[:alert]).to eq("Recipe not found.")
        end
      end

      context "when meals array is empty" do
        before do
          allow(HTTParty).to receive(:get).and_return(
            double(success?: true, parsed_response: { "meals" => [] })
          )
        end

        it "redirects to recipes path" do
          get :show, params: { id: meal_id }
          expect(response).to redirect_to(recipes_path)
        end

        it "sets a not found alert message" do
          get :show, params: { id: meal_id }
          expect(flash[:alert]).to eq("Recipe not found.")
        end
      end
    end
  end
end