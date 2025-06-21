class RecipeXlsxController < ApplicationController
  before_action :set_recipe, only: [ :export, :import ]

  def export
    respond_to do |format|
      format.xlsx do
        response.headers["Content-Disposition"] = "attachment; filename=\"#{@recipe.name.parameterize}_#{Date.current}.xlsx\""
        render xlsx: "export", filename: "#{@recipe.name.parameterize}_#{Date.current}.xlsx"
      end
    end
  end

  def import
    if params[:file].present?
      begin
        import_from_xlsx(params[:file])
        redirect_to @recipe, notice: t("xlsx.import_success")
      rescue => e
        Rails.logger.error "XLSX Import Error: #{e.message}"
        redirect_to @recipe, alert: t("xlsx.import_error")
      end
    else
      redirect_to @recipe, alert: t("xlsx.invalid_file")
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def import_from_xlsx(file)
    xlsx = Roo::Excelx.new(file.tempfile)

    # Import ingredients from "Bahan" sheet
    if xlsx.sheets.include?("Bahan")
      xlsx.sheet("Bahan")
      headers = xlsx.row(1)

      (2..xlsx.last_row).each do |i|
        row = xlsx.row(i)
        next if row.compact.empty?

        ingredient_name = row[headers.index("Nama Bahan")]
        quantity = row[headers.index("Jumlah")]
        unit = row[headers.index("Satuan")]

        next unless ingredient_name && quantity

        # Find or create ingredient
        ingredient = Ingredient.find_or_create_by(name: ingredient_name) do |ing|
          ing.unit = unit || "gram"
          ing.price = 0 # Default price, can be updated later
        end

        # Update or create recipe ingredient
        recipe_ingredient = @recipe.recipe_ingredients.find_or_initialize_by(ingredient: ingredient)
        recipe_ingredient.quantity = quantity
        recipe_ingredient.save!
      end
    end

    # Import recipe details from "Resep" sheet
    if xlsx.sheets.include?("Resep")
      xlsx.sheet("Resep")

      # Look for specific cells with recipe data
      (1..xlsx.last_row).each do |i|
        row = xlsx.row(i)
        next if row.compact.empty?

        if row[0] == "Instruksi"
          instructions = row[1]
          @recipe.update!(instructions: instructions) if instructions.present?
        elsif row[0] == "Porsi"
          servings = row[1].to_i
          @recipe.update!(servings: servings) if servings > 0
        elsif row[0] == "Waktu Persiapan"
          prep_time = row[1].to_i
          @recipe.update!(preparation_time: prep_time) if prep_time > 0
        end
      end
    end
  end
end
