class IngredientTypesController < ApplicationController
  before_action :set_ingredient_type, only: [ :edit, :update, :destroy ]

  def index
    @q = IngredientType.ransack(params[:q])
    @ingredient_types_scope = @q.result(distinct: true)
    @pagy, @ingredient_types = pagy(@ingredient_types_scope.order(:name), items: 10)
  end

  def new
    @ingredient_type = IngredientType.new
  end

  def create
    @ingredient_type = IngredientType.new(ingredient_type_params)

    if @ingredient_type.save
      redirect_to ingredient_types_path, notice: "Jenis bahan berhasil ditambahkan."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @ingredient_type.update(ingredient_type_params)
      redirect_to ingredient_types_path, notice: "Jenis bahan berhasil diperbarui."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @ingredient_type.destroy
    redirect_to ingredient_types_path, notice: "Jenis bahan berhasil dihapus."
  end

  private

  def set_ingredient_type
    @ingredient_type = IngredientType.find(params[:id])
  end

  def ingredient_type_params
    params.require(:ingredient_type).permit(:name, :description)
  end
end
