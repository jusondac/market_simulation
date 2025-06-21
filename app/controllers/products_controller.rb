class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.includes(:recipe).order(:name)
  end

  def show
  end

  def new
    @product = Product.new
    @recipes = Recipe.all.order(:name)
  end

  def create
    @product = Product.new(product_params)
    
    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      @recipes = Recipe.all.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @recipes = Recipe.all.order(:name)
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      @recipes = Recipe.all.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully deleted.'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:recipe_id, :name, :margin)
  end
end
