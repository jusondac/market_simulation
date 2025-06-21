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

    # Import ingredients from "Bahan" sheet
    if xlsx.sheets.include?("Bahan")
      xlsx.sheet("Bahan")
      headers = xlsx.row(1)

      (2..xlsx.last_row).each do |i|
        row = xlsx.row(i)
        next if row.compact.empty?

        name = row[headers.index("Nama Bahan")]
        price = row[headers.index("Harga")]
        unit = row[headers.index("Satuan")]
        description = row[headers.index("Deskripsi")]

        next unless name && price && unit

        # Find or create ingredient
        ingredient = Ingredient.find_or_initialize_by(name: name)
        ingredient.assign_attributes(
          price: price.to_f,
          unit: unit,
          description: description
        )

        ingredient.save!
      end
    else
      # Fallback to first sheet if "Bahan" sheet doesn't exist
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
