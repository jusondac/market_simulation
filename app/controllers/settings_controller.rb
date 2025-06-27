class SettingsController < ApplicationController
  def index
    @units = Unit.by_name.limit(10)
    @ingredient_types = IngredientType.by_name.limit(10)
  end
end
