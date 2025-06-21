# Configure caxlsx_rails for Excel export functionality

# Ensure proper MIME type registration
Mime::Type.register "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :xlsx unless Mime::Type.lookup_by_extension(:xlsx)

# Configure default settings for caxlsx
if defined?(Caxlsx)
  # Set default author for Excel files
  Caxlsx.configure do |config|
    # You can set default configuration here if needed
  end
end
