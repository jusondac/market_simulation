class ProductsXlsxController < ApplicationController
  def export
    @products = Product.includes(:recipe).order(:name)

    respond_to do |format|
      format.xlsx do
        response.headers["Content-Disposition"] = "attachment; filename=\"produk_#{Date.current}.xlsx\""
        render xlsx: "export", filename: "produk_#{Date.current}.xlsx"
      end
    end
  end

  def import
    if params[:file].present?
      begin
        import_from_xlsx(params[:file])
        redirect_to products_path, notice: "Data produk berhasil diimpor dari file Excel."
      rescue => e
        Rails.logger.error "XLSX Import Error: #{e.message}"
        redirect_to products_path, alert: "Terjadi kesalahan saat mengimpor file Excel. Pastikan format file sudah benar."
      end
    else
      redirect_to products_path, alert: "Silakan pilih file Excel untuk diimpor."
    end
  end

  private

  def import_from_xlsx(file)
    xlsx = Roo::Excelx.new(file.tempfile)

    # Import products from "Produk" sheet
    if xlsx.sheets.include?("Produk")
      xlsx.sheet("Produk")
      headers = xlsx.row(1)

      (2..xlsx.last_row).each do |i|
        row = xlsx.row(i)
        next if row.compact.empty?

        name = row[headers.index("Nama Produk")]
        recipe_name = row[headers.index("Resep")]
        price = row[headers.index("Harga Jual")]
        margin = row[headers.index("Margin (%)")]

        next unless name && recipe_name && price

        # Find the recipe
        recipe = Recipe.find_by(name: recipe_name)
        next unless recipe

        # Find or create product
        product = Product.find_or_initialize_by(name: name, recipe: recipe)
        product.assign_attributes(
          price: price.to_f,
          margin: margin.to_f
        )

        product.save!
      end
    end
  end
end
