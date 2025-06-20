class RecipeIngredientsController < ApplicationController
  before_action :set_recipe
  before_action :set_recipe_ingredient, only: [ :destroy ]

  def create
    @recipe_ingredient = @recipe.recipe_ingredients.build(recipe_ingredient_params)

    if @recipe_ingredient.save
      redirect_to @recipe, notice: "Ingredient added to recipe."
    else
      redirect_to @recipe, alert: "Failed to add ingredient to recipe."
    end
  end

  def destroy
    @recipe_ingredient.destroy
    redirect_to @recipe, notice: "Ingredient removed from recipe."
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def set_recipe_ingredient
    @recipe_ingredient = @recipe.recipe_ingredients.find(params[:id])
  end

  def recipe_ingredient_params
    params.require(:recipe_ingredient).permit(:ingredient_id, :quantity)
  end
end
