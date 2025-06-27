class SettingsController < ApplicationController
  def index
    @units = Unit.includes(:ingredients).by_name
    @ingredient_types = IngredientType.includes(:ingredients).by_name
  end
end
