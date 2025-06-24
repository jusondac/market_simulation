class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def index
    @q = Recipe.ransack(params[:q])
    
    # Apply filters and ordering
    @recipes_scope = @q.result(distinct: true).includes(:ingredients, :recipe_ingredients)
    
    # Add pagination
    @pagy, @recipes = pagy(@recipes_scope.order(:name), items: 10)
  end

  def show
    @recipe_ingredients = @recipe.recipe_ingredients.includes(:ingredient)
  end

  def new
    @recipe = Recipe.new
    @recipe.recipe_ingredients.build
    @ingredients = Ingredient.all.order(:name)
  end

  def create
    @recipe = Recipe.new(recipe_params)
    
    if @recipe.save
      redirect_to @recipe, notice: 'Recipe was successfully created.'
    else
      @ingredients = Ingredient.all.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @ingredients = Ingredient.all.order(:name)
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: 'Recipe was successfully updated.'
    else
      @ingredients = Ingredient.all.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_url, notice: 'Recipe was successfully deleted.'
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:name, :description, :instructions, :servings, :preparation_time,
                                   recipe_ingredients_attributes: [:id, :ingredient_id, :quantity, :_destroy])
  end
end
