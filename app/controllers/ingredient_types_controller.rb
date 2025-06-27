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

    respond_to do |format|
      if @ingredient_type.save
        format.html { redirect_to settings_path, notice: "Jenis bahan berhasil ditambahkan." }
        format.js { head :ok }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js { head :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @ingredient_type.update(ingredient_type_params)
        format.html { redirect_to settings_path, notice: "Jenis bahan berhasil diperbarui." }
        format.js { head :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.js { head :unprocessable_entity }
      end
    end
  end

  def destroy
    @ingredient_type.destroy
    redirect_to settings_path, notice: "Jenis bahan berhasil dihapus."
  end

  private

  def set_ingredient_type
    @ingredient_type = IngredientType.find(params[:id])
  end

  def ingredient_type_params
    params.require(:ingredient_type).permit(:name)
  end
end
