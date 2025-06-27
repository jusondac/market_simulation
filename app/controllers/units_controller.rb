class UnitsController < ApplicationController
  before_action :set_unit, only: [ :edit, :update, :destroy ]

  def index
    @q = Unit.ransack(params[:q])
    @units_scope = @q.result(distinct: true)
    @pagy, @units = pagy(@units_scope.order(:name), items: 10)
  end

  def new
    @unit = Unit.new
  end

  def create
    @unit = Unit.new(unit_params)

    respond_to do |format|
      if @unit.save
        format.html { redirect_to settings_path, notice: "Satuan berhasil ditambahkan." }
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
      if @unit.update(unit_params)
        format.html { redirect_to settings_path, notice: "Satuan berhasil diperbarui." }
        format.js { head :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.js { head :unprocessable_entity }
      end
    end
  end

  def destroy
    @unit.destroy
    redirect_to settings_path, notice: "Satuan berhasil dihapus."
  end

  private

  def set_unit
    @unit = Unit.find(params[:id])
  end

  def unit_params
    params.require(:unit).permit(:name)
  end
end
