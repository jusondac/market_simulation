class PackagingsController < ApplicationController
  before_action :set_packaging, only: [ :show, :edit, :update, :destroy ]

  def index
    @q = Packaging.ransack(params[:q])
    @packagings = @q.result(distinct: true).order(:name)
    @pagy, @packagings = pagy(@packagings, limit: 15)
  end

  def show
  end

  def new
    @packaging = Packaging.new
  end

  def create
    @packaging = Packaging.new(packaging_params)

    if @packaging.save
      redirect_to @packaging, notice: "Packaging berhasil dibuat."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @packaging.update(packaging_params)
      redirect_to @packaging, notice: "Packaging berhasil diupdate."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @packaging.destroy
    redirect_to packagings_url, notice: "Packaging berhasil dihapus."
  end

  private

  def set_packaging
    @packaging = Packaging.find(params[:id])
  end

  def packaging_params
    params.require(:packaging).permit(:name, :size, :box, :price, :capacity, :material)
  end
end
