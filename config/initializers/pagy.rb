# Pagy configuration
require "pagy/extras/overflow"

# Set default page size
Pagy::DEFAULT[:items] = 10

# Handle overflow pages
Pagy::DEFAULT[:overflow] = :last_page
