class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [ :show, :edit, :update, :destroy ]

  def index
    @ingredients = Ingredient.all.order(:name)
  end

  def show
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)

    if @ingredient.save
      redirect_to @ingredient, notice: "Ingredient was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @ingredient.update(ingredient_params)
      redirect_to @ingredient, notice: "Ingredient was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ingredient.destroy
    redirect_to ingredients_url, notice: "Ingredient was successfully deleted."
  end

  private

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  def ingredient_params
    params.require(:ingredient).permit(:name, :price, :unit, :description)
  end
end
