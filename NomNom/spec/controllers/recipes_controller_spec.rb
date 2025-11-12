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

    # -------------------------
    # INDEX
    # -------------------------
    describe "GET #index" do
      context "without ingredient parameter" do
        it "returns a success response and assigns empty @meals" do
          get :index
          expect(response).to be_successful
          expect(assigns(:meals)).to eq([])
        end

        it "assigns empty @meals and sets flash alert when API call fails" do
          # Stub HTTParty to simulate failed API
          allow(HTTParty).to receive(:get).and_return(double(success?: false))

          get :index, params: { ingredient: "chicken" }

          expect(assigns(:meals)).to eq([])
          expect(flash.now[:alert]).to eq("There was an error fetching recipes. Please try again.")
        end
      end

      context "with ingredient parameter" do
        let(:mock_response) do
          {
            "meals" => [
              { "strMeal" => "Chicken Curry", "strMealThumb" => "url1", "idMeal" => "52796" },
              { "strMeal" => "Chicken Soup", "strMealThumb" => "url2", "idMeal" => "52797" }
            ]
          }
        end

        before do
          allow(HTTParty).to receive(:get)
            .and_return(double(success?: true, parsed_response: mock_response))
        end

        it "assigns the meals from the API response" do
          get :index, params: { ingredient: "chicken" }
          expect(assigns(:meals)).to eq(mock_response["meals"])
        end
      end
    end

    # -------------------------
    # SHOW
    # -------------------------
    describe "GET #show" do
      let(:meal_id) { "52796" }
      let(:mock_meal_data) { { "meals" => [{ "idMeal" => meal_id, "strMeal" => "Chicken Curry" }] } }

      before do
        allow(HTTParty).to receive(:get)
          .and_return(double(success?: true, parsed_response: mock_meal_data))
      end

      it "assigns the meal data to @meal" do
        get :show, params: { id: meal_id }
        expect(assigns(:meal)).to eq(mock_meal_data["meals"].first)
      end

      it "redirects to recipes_path with alert if API fails" do
        allow(HTTParty).to receive(:get).and_return(double(success?: false))
        get :show, params: { id: meal_id }
        expect(response).to redirect_to(recipes_path)
        expect(flash[:alert]).to eq("Error fetching recipe details.")
      end

      it "redirects to recipes_path with alert if meal not found" do
        allow(HTTParty).to receive(:get).and_return(double(success?: true, parsed_response: { "meals" => [] }))
        get :show, params: { id: meal_id }
        expect(response).to redirect_to(recipes_path)
        expect(flash[:alert]).to eq("Recipe not found.")
      end
    end

    # -------------------------
    # NEW
    # -------------------------
    describe "GET #new" do
      it "assigns a new recipe with a built recipe ingredient and all ingredients" do
        ingredient = create(:ingredient, name: "Sugar")

        # Only stub render for this action to avoid MissingTemplate errors
        allow(controller).to receive(:render)

        get :new

        expect(assigns(:recipe)).to be_a_new(Recipe)
        expect(assigns(:recipe).recipe_ingredients.size).to eq(1)
        expect(assigns(:ingredients)).to include(ingredient)
      end
    end

    # -------------------------
    # CREATE
    # -------------------------
    describe "POST #create" do
      context "with valid params" do
        let(:ingredient) { create(:ingredient) }
        let(:recipe_params) do
          {
            name: "Test Recipe",
            description: "Delicious",
            recipe_ingredients_attributes: { "0" => { ingredient_id: ingredient.id, quantity: 2 } }
          }
        end

        it "creates a recipe and redirects with notice" do
          post :create, params: { recipe: recipe_params }

          recipe = assigns(:recipe)
          expect(recipe.name).to eq("Test Recipe")
          expect(response).to redirect_to(recipe_path(recipe))
          expect(flash[:notice]).to eq("Recipe created successfully!")
        end
      end

      context "with inline new ingredient" do
        let(:recipe_params_with_new_ingredient) do
          {
            name: "Smoothie",
            description: "Tasty",
            recipe_ingredients_attributes: {
              "0" => {
                ingredient_id: "", # triggers inline creation
                ingredient_attributes: { name: "Banana", calories_per_unit: 100 },
                quantity: 2
              }
            }
          }
        end

        it "creates the ingredient inline and saves the recipe" do
          expect {
            post :create, params: { recipe: recipe_params_with_new_ingredient }
          }.to change(Ingredient, :count).by(1)
            .and change(Recipe, :count).by(1)

          recipe = assigns(:recipe)
          expect(recipe.recipe_ingredients.first.ingredient.name).to eq("Banana")
          expect(recipe.recipe_ingredients.first.quantity).to eq(2)
          expect(response).to redirect_to(recipe_path(recipe))
          expect(flash[:notice]).to eq("Recipe created successfully!")
        end
      end

      context "when saving recipe fails" do
        let(:invalid_recipe_params) do
          {
            name: "",
            description: "No name",
            recipe_ingredients_attributes: {
              "0" => { ingredient_id: "", ingredient_attributes: { name: "Banana", calories_per_unit: 100 }, quantity: 2 }
            }
          }
        end

        it "renders :new and assigns @ingredients" do
          allow_any_instance_of(Recipe).to receive(:save).and_return(false)
          allow(controller).to receive(:render).with(:new, status: :unprocessable_entity).and_return(nil)

          post :create, params: { recipe: invalid_recipe_params }

          expect(assigns(:ingredients)).to eq(Ingredient.all)
          expect(assigns(:recipe)).to be_a(Recipe)
        end
      end
    end
  end
end
