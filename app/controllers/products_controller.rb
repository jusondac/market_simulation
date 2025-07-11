class ProductsController < ApplicationController
  before_action :set_product, only: [ :show, :edit, :update, :destroy, :manage_packaging, :add_packaging, :remove_packaging ]

  def index
    @q = Product.ransack(params[:q])

    # Apply filters and ordering
    @products_scope = @q.result(distinct: true).includes(:recipe, :product_recipes)

    # Add pagination
    @pagy, @products = pagy(@products_scope.order(:name), items: 10)
  end

  def show
  end

  def new
    @product = Product.new
    @recipes = Recipe.all.order(:name)
    @product.product_recipes.build # Build empty product_recipe for form
  end

  def create
    @product = Product.new(product_params)

    # Jika menggunakan multiple recipes, hapus recipe_id yang lama
    if params[:recipe_mode] == "multiple"
      @product.recipe_id = nil
    end

    if @product.save
      redirect_to @product, notice: "Product was successfully created."
    else
      @recipes = Recipe.all.order(:name)
      # Build empty product_recipe jika belum ada untuk error handling
      @product.product_recipes.build if @product.product_recipes.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @recipes = Recipe.all.order(:name)
    # Build empty product_recipe jika belum ada
    @product.product_recipes.build if @product.product_recipes.empty?
  end

  def update
    # Jika menggunakan multiple recipes, hapus recipe_id yang lama
    if params[:recipe_mode] == "multiple"
      @product.recipe_id = nil
    end

    if @product.update(product_params)
      respond_to do |format|
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render json: { status: "success", message: "Product updated successfully" } }
      end
    else
      respond_to do |format|
        format.html do
          @recipes = Recipe.all.order(:name)
          # Build empty product_recipe jika belum ada untuk error handling
          @product.product_recipes.build if @product.product_recipes.empty?
          render :edit, status: :unprocessable_entity
        end
        format.json { render json: { status: "error", errors: @product.errors.full_messages } }
      end
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: "Product was successfully deleted."
  end

  def manage_packaging
    @available_packagings = Packaging.all.order(:name)
    @product_packagings = @product.product_packagings.includes(:packaging)
  end

  def add_packaging
    @packaging = Packaging.find(params[:packaging_id])
    @product_packaging = @product.product_packagings.build(packaging: @packaging)

    if @product_packaging.save
      redirect_to manage_packaging_product_path(@product), notice: "Packaging berhasil ditambahkan."
    else
      redirect_to manage_packaging_product_path(@product), alert: "Gagal menambahkan packaging."
    end
  end

  def remove_packaging
    @product_packaging = @product.product_packagings.find(params[:product_packaging_id])
    @product_packaging.destroy
    redirect_to manage_packaging_product_path(@product), notice: "Packaging berhasil dihapus."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:recipe_id, :name, :margin,
      product_recipes_attributes: [ :id, :recipe_id, :recipe_type, :quantity, :_destroy ])
  end
end
