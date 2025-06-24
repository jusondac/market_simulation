class IngredientsXlsxController < ApplicationController
  def export
    @ingredients = Ingredient.includes(:recipes, :recipe_ingredients).order(:name)

    # Pre-calculate statistics to avoid N+1 queries in the view
    @ingredient_stats = @ingredients.map do |ingredient|
      {
        ingredient: ingredient,
        recipe_count: ingredient.recipes.size,
        total_usage: ingredient.recipe_ingredients.sum(&:quantity)
      }
    end

    respond_to do |format|
      format.xlsx do
        response.headers["Content-Disposition"] = "attachment; filename=\"bahan-bahan_#{Date.current}.xlsx\""
      end
    end
  end

  def import
    if params[:file].present?
      begin
        import_from_xlsx(params[:file])
        redirect_to ingredients_path, notice: "Data bahan berhasil diimpor dari file Excel."
      rescue => e
        Rails.logger.error "XLSX Import Error: #{e.message}"
        redirect_to ingredients_path, alert: "Terjadi kesalahan saat mengimpor file Excel. Pastikan format file sudah benar."
      end
    else
      redirect_to ingredients_path, alert: "Silakan pilih file Excel untuk diimpor."
    end
  end

  private

  def import_from_xlsx(file)
    xlsx = Roo::Excelx.new(file.tempfile)
    updated_ingredients = []
    imported_codes = []

    # Import ingredients from "Bahan" sheet
    if xlsx.sheets.include?("Bahan")
      xlsx.sheet("Bahan")
      headers = xlsx.row(1)

      # Skip header and note rows (start from row 4)
      start_row = 4
      (start_row..xlsx.last_row).each do |i|
        row = xlsx.row(i)
        next if row.compact.empty?

        ingredient_code = row[headers.index("Kode Bahan")]
        name = row[headers.index("Nama Bahan")]
        price = row[headers.index("Harga")]
        unit = row[headers.index("Satuan")]
        description = row[headers.index("Deskripsi")]

        next unless ingredient_code && name && price && unit

        imported_codes << ingredient_code

        # Find ingredient by code
        ingredient = Ingredient.find_by(ingredient_code: ingredient_code)

        if ingredient
          # Update existing ingredient
          ingredient.assign_attributes(
            name: name,
            price: price.to_f,
            unit: unit,
            description: description
          )
          ingredient.save!
          updated_ingredients << ingredient
        else
          # This should not happen in normal flow since codes shouldn't change
          # But we'll handle it gracefully
          Rails.logger.warn "Ingredient with code #{ingredient_code} not found, skipping"
        end
      end

      # Remove ingredients that are not in the import file
      existing_ingredients = Ingredient.all
      ingredients_to_remove = existing_ingredients.reject { |ing| imported_codes.include?(ing.ingredient_code) }

      # Check if any recipes use ingredients that will be removed
      ingredients_with_recipes = ingredients_to_remove.select { |ing| ing.recipes.any? }

      if ingredients_with_recipes.any?
        # Remove recipe ingredients first to avoid constraint issues
        ingredients_with_recipes.each do |ingredient|
          ingredient.recipe_ingredients.destroy_all
        end

        # Log which recipes were affected
        affected_recipes = ingredients_with_recipes.flat_map(&:recipes).uniq
        Rails.logger.info "Removed ingredients from recipes: #{affected_recipes.map(&:name).join(', ')}"
      end

      # Now remove the ingredients
      ingredients_to_remove.each(&:destroy)

    else
      # Fallback to old method if "Bahan" sheet doesn't exist
      xlsx.sheet(0)
      headers = xlsx.row(1)

      (2..xlsx.last_row).each do |i|
        row = xlsx.row(i)
        next if row.compact.empty?

        # Try to map columns by position (name, price, unit, description)
        name = row[0]
        price = row[1]
        unit = row[2]
        description = row[3]

        next unless name && price && unit

        ingredient = Ingredient.find_or_initialize_by(name: name)
        ingredient.assign_attributes(
          price: price.to_f,
          unit: unit,
          description: description
        )

        ingredient.save!
      end
    end
  end
end
