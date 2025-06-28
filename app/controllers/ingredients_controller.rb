class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [ :show, :edit, :update, :destroy ]

  def index
    @q = Ingredient.ransack(params[:q])

    # Apply filters and ordering
    @ingredients_scope = @q.result(distinct: true).includes(:recipes)

    # Add pagination
    @pagy, @ingredients = pagy(@ingredients_scope.order(:name), items: 10)
  end

  def show
  end

  def new
    @ingredient = Ingredient.new
    @ingredient.build_ingredient_detail
    @units = Unit.by_name
    @ingredient_types = IngredientType.by_name
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)

    if @ingredient.save
      redirect_to @ingredient, notice: "Bahan berhasil ditambahkan."
    else
      @units = Unit.by_name
      @ingredient_types = IngredientType.by_name
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @ingredient.build_ingredient_detail if @ingredient.ingredient_detail.nil?
    @units = Unit.by_name
    @ingredient_types = IngredientType.by_name
  end

  def update
    if @ingredient.update(ingredient_params)
      redirect_to @ingredient, notice: "Ingredient was successfully updated."
    else
      @units = Unit.by_name
      @ingredient_types = IngredientType.by_name
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ingredient.destroy
    redirect_to ingredients_url, notice: "Ingredient was successfully deleted."
  end

  def unit_converter
    # Page for unit conversion utility
  end

  private

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  def ingredient_params
    params.require(:ingredient).permit(:name, :price, :quantity, :unit, :description, :ingredient_code, :ingredient_type,
                                      ingredient_detail_attributes: [ :id, :package_size, :package_unit, :_destroy ])
  end
end
