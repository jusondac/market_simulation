# Clear existing data
puts "Clearing existing data..."
SimulationResult.destroy_all
SimulationProduct.destroy_all
MarketSimulation.destroy_all
ProductPackaging.destroy_all
Packaging.destroy_all
Product.destroy_all
RecipeIngredient.destroy_all
Recipe.destroy_all
Ingredient.destroy_all
Person.destroy_all
Unit.destroy_all
IngredientType.destroy_all

# Create Units
puts "Creating units..."
units_data = [
  { name: "g" },
  { name: "kg" },
  { name: "cup" },
  { name: "tbsp" },
  { name: "tsp" },
  { name: "lb" },
  { name: "oz" },
  { name: "piece" },
  { name: "package" },
  { name: "ml" },
  { name: "l" }
]

units_data.each do |unit_data|
  Unit.create!(unit_data)
end

# Create Ingredient Types
puts "Creating ingredient types..."
ingredient_types_data = [
  { name: "kemasan" },
  { name: "mentah" }
]

ingredient_types_data.each do |type_data|
  IngredientType.create!(type_data)
end

# puts "Creating ingredients..."

# # Create ingredients with package details examples
# # Regular ingredients (mentah type)
# ingredients = [
#   { name: "Flour", price: 5000, unit: "kg", description: "All-purpose flour", ingredient_type: "mentah" },
#   { name: "Sugar", price: 8000, unit: "kg", description: "White granulated sugar", ingredient_type: "mentah" },
#   { name: "Eggs", price: 2500, unit: "piece", description: "Fresh eggs", ingredient_type: "mentah" },
# ]

# # Package ingredients (kemasan type) - will need ingredient_details
# package_ingredients = [
#   {
#     name: "Basreng",
#     price: 10000,
#     unit: "package",
#     description: "Spicy fried meatballs snack",
#     ingredient_type: "kemasan",
#     ingredient_detail: { package_size: 10, package_unit: "piece" }
#   },
#   {
#     name: "Tepung Bumbu Sajiku",
#     price: 3500,
#     unit: "package",
#     description: "Seasoned flour mix",
#     ingredient_type: "kemasan",
#     ingredient_detail: { package_size: 80, package_unit: "g" }
#   }
# ]

# # Create regular ingredients
# ingredients.each do |ingredient_data|
#   Ingredient.create!(ingredient_data)
# end

# # Create package ingredients with details
# package_ingredients.each do |ingredient_data|
#   ingredient_detail_data = ingredient_data.delete(:ingredient_detail)
#   ingredient = Ingredient.create!(ingredient_data)
#   ingredient.create_ingredient_detail!(ingredient_detail_data)
# end
#   { name: "Butter", price: 3.00, unit: "cup", description: "Unsalted butter", ingredient_type: "kemasan" },
#   { name: "Milk", price: 1.50, unit: "cup", description: "Whole milk", ingredient_type: "kemasan" },
#   { name: "Chocolate Chips", price: 4.00, unit: "cup", description: "Semi-sweet chocolate chips", ingredient_type: "kemasan" },
#   { name: "Vanilla Extract", price: 0.75, unit: "tsp", description: "Pure vanilla extract", ingredient_type: "kemasan" },
#   { name: "Baking Powder", price: 0.25, unit: "tsp", description: "Double-acting baking powder", ingredient_type: "kemasan" },
#   { name: "Salt", price: 0.10, unit: "tsp", description: "Table salt", ingredient_type: "kemasan" },
#   { name: "Cocoa Powder", price: 1.25, unit: "tbsp", description: "Unsweetened cocoa powder", ingredient_type: "kemasan" },
#   { name: "Cream Cheese", price: 2.00, unit: "oz", description: "Philadelphia cream cheese", ingredient_type: "kemasan" },
#   { name: "Strawberries", price: 3.50, unit: "cup", description: "Fresh strawberries", ingredient_type: "mentah" },
#   { name: "Banana", price: 0.75, unit: "piece", description: "Ripe banana", ingredient_type: "mentah" },
#   { name: "Oats", price: 1.20, unit: "cup", description: "Rolled oats", ingredient_type: "kemasan" },
#   { name: "Honey", price: 2.25, unit: "tbsp", description: "Pure honey", ingredient_type: "kemasan" }
# ]

# ingredients.each do |ingredient_attrs|
#   Ingredient.create!(ingredient_attrs)
# end

puts "Creating people with different taste preferences..."

# Create people with different demographics and taste preferences
people_data = [
  # Kids
  { name: "Emma", age: 8, taste_preferences: [ "sweet", "chocolate", "vanilla", "strawberry" ] },
  { name: "Liam", age: 10, taste_preferences: [ "chocolate", "banana", "sweet" ] },
  { name: "Olivia", age: 7, taste_preferences: [ "strawberry", "vanilla", "sweet" ] },
  { name: "Noah", age: 9, taste_preferences: [ "chocolate", "cookie", "sweet" ] },
  { name: "Sophia", age: 11, taste_preferences: [ "vanilla", "strawberry", "sweet" ] },

  # Teenagers
  { name: "Ava", age: 15, taste_preferences: [ "chocolate", "coffee", "sweet" ] },
  { name: "William", age: 17, taste_preferences: [ "vanilla", "banana", "healthy" ] },
  { name: "Isabella", age: 14, taste_preferences: [ "strawberry", "cream", "sweet" ] },
  { name: "James", age: 16, taste_preferences: [ "chocolate", "nuts", "energy" ] },
  { name: "Charlotte", age: 18, taste_preferences: [ "healthy", "oats", "honey" ] },

  # Adults
  { name: "Benjamin", age: 28, taste_preferences: [ "coffee", "dark chocolate", "sophisticated" ] },
  { name: "Amelia", age: 32, taste_preferences: [ "healthy", "low sugar", "natural" ] },
  { name: "Lucas", age: 24, taste_preferences: [ "sweet", "nostalgic", "comfort" ] },
  { name: "Harper", age: 29, taste_preferences: [ "gourmet", "unique", "artisanal" ] },
  { name: "Alexander", age: 35, taste_preferences: [ "classic", "simple", "quality" ] },
  { name: "Evelyn", age: 26, taste_preferences: [ "healthy", "fruit", "natural" ] },
  { name: "Henry", age: 31, taste_preferences: [ "rich", "indulgent", "premium" ] },
  { name: "Abigail", age: 27, taste_preferences: [ "balanced", "moderate", "wholesome" ] }
]

people_data.each do |person_attrs|
  Person.create!(person_attrs)
end

puts "Creating recipes..."

# # Create recipes
# flour = Ingredient.find_by(name: "Flour")
# sugar = Ingredient.find_by(name: "Sugar")
# eggs = Ingredient.find_by(name: "Eggs")
# butter = Ingredient.find_by(name: "Butter")
# milk = Ingredient.find_by(name: "Milk")
# chocolate_chips = Ingredient.find_by(name: "Chocolate Chips")
# vanilla = Ingredient.find_by(name: "Vanilla Extract")
# baking_powder = Ingredient.find_by(name: "Baking Powder")
# salt = Ingredient.find_by(name: "Salt")
# cocoa = Ingredient.find_by(name: "Cocoa Powder")
# cream_cheese = Ingredient.find_by(name: "Cream Cheese")
# strawberries = Ingredient.find_by(name: "Strawberries")
# banana = Ingredient.find_by(name: "Banana")
# oats = Ingredient.find_by(name: "Oats")
# honey = Ingredient.find_by(name: "Honey")

# # Chocolate Chip Cookies
# cookie_recipe = Recipe.create!(
#   name: "Classic Chocolate Chip Cookies",
#   description: "Delicious homemade chocolate chip cookies that everyone loves",
#   instructions: "1. Preheat oven to 375°F. 2. Mix butter and sugars. 3. Add eggs and vanilla. 4. Combine dry ingredients. 5. Fold in chocolate chips. 6. Bake for 9-11 minutes.",
#   servings: 24,
#   preparation_time: 45
# )

# [
#   { ingredient: flour, quantity: 2.25 },
#   { ingredient: baking_powder, quantity: 1 },
#   { ingredient: salt, quantity: 1 },
#   { ingredient: butter, quantity: 1 },
#   { ingredient: sugar, quantity: 0.75 },
#   { ingredient: eggs, quantity: 2 },
#   { ingredient: vanilla, quantity: 2 },
#   { ingredient: chocolate_chips, quantity: 2 }
# ].each do |ri|
#   cookie_recipe.recipe_ingredients.create!(ingredient: ri[:ingredient], quantity: ri[:quantity])
# end

# # Strawberry Cheesecake
# cheesecake_recipe = Recipe.create!(
#   name: "Strawberry Cheesecake",
#   description: "Creamy cheesecake topped with fresh strawberries",
#   instructions: "1. Prepare crust. 2. Mix cream cheese filling. 3. Bake at 325°F for 60 minutes. 4. Cool and top with strawberries.",
#   servings: 12,
#   preparation_time: 180
# )

# [
#   { ingredient: cream_cheese, quantity: 32 },
#   { ingredient: sugar, quantity: 1 },
#   { ingredient: eggs, quantity: 4 },
#   { ingredient: vanilla, quantity: 2 },
#   { ingredient: strawberries, quantity: 2 }
# ].each do |ri|
#   cheesecake_recipe.recipe_ingredients.create!(ingredient: ri[:ingredient], quantity: ri[:quantity])
# end

# # Banana Oat Muffins
# muffin_recipe = Recipe.create!(
#   name: "Healthy Banana Oat Muffins",
#   description: "Nutritious muffins perfect for breakfast",
#   instructions: "1. Mash bananas. 2. Mix wet ingredients. 3. Combine dry ingredients. 4. Fold together. 5. Bake at 350°F for 20 minutes.",
#   servings: 12,
#   preparation_time: 35
# )

# [
#   { ingredient: flour, quantity: 1.5 },
#   { ingredient: oats, quantity: 1 },
#   { ingredient: baking_powder, quantity: 2 },
#   { ingredient: salt, quantity: 0.5 },
#   { ingredient: banana, quantity: 3 },
#   { ingredient: honey, quantity: 4 },
#   { ingredient: milk, quantity: 0.5 },
#   { ingredient: eggs, quantity: 2 }
# ].each do |ri|
#   muffin_recipe.recipe_ingredients.create!(ingredient: ri[:ingredient], quantity: ri[:quantity])
# end

# # Chocolate Brownies
# brownie_recipe = Recipe.create!(
#   name: "Fudgy Chocolate Brownies",
#   description: "Rich and fudgy brownies for chocolate lovers",
#   instructions: "1. Melt butter and chocolate. 2. Mix in sugar and eggs. 3. Add flour and cocoa. 4. Bake at 350°F for 25 minutes.",
#   servings: 16,
#   preparation_time: 50
# )

# [
#   { ingredient: butter, quantity: 0.5 },
#   { ingredient: cocoa, quantity: 6 },
#   { ingredient: sugar, quantity: 1.5 },
#   { ingredient: eggs, quantity: 3 },
#   { ingredient: flour, quantity: 0.75 },
#   { ingredient: vanilla, quantity: 1 },
#   { ingredient: salt, quantity: 0.5 }
# ].each do |ri|
#   brownie_recipe.recipe_ingredients.create!(ingredient: ri[:ingredient], quantity: ri[:quantity])
# end

# puts "Creating products..."

# # Create products from recipes
# Product.create!(
#   recipe: cookie_recipe,
#   name: "Chocolate Chip Cookie Pack (12 pieces)",
#   margin: 150, # 150% markup
#   price: 0, # Will be calculated
#   cost: 0 # Will be calculated
# )

# Product.create!(
#   recipe: cheesecake_recipe,
#   name: "Strawberry Cheesecake Slice",
#   margin: 200, # 200% markup
#   price: 0,
#   cost: 0
# )

# Product.create!(
#   recipe: muffin_recipe,
#   name: "Banana Oat Muffin (4 pack)",
#   margin: 120, # 120% markup
#   price: 0,
#   cost: 0
# )

# Product.create!(
#   recipe: brownie_recipe,
#   name: "Fudgy Brownie Square",
#   margin: 180, # 180% markup
#   price: 0,
#   cost: 0
# )

# Create Packaging
puts "Creating packaging..."
packaging_data = [
  # Botol Plastik
  {
    name: "Botol Plastik PET 330ml",
    size: "330ml",
    box: "Kardus 24 pcs",
    price: 1500,
    capacity: 330,
    material: "plastik"
  },
  {
    name: "Botol Plastik PET 500ml",
    size: "500ml",
    box: "Kardus 24 pcs",
    price: 2000,
    capacity: 500,
    material: "plastik"
  },
  {
    name: "Botol Plastik PET 1L",
    size: "1 Liter",
    box: "Kardus 12 pcs",
    price: 3500,
    capacity: 1000,
    material: "plastik"
  },

  # Gelas Plastik
  {
    name: "Gelas Plastik PP 240ml",
    size: "240ml (8oz)",
    box: "Sleeve 50 pcs",
    price: 800,
    capacity: 240,
    material: "plastik"
  },
  {
    name: "Gelas Plastik PP 350ml",
    size: "350ml (12oz)",
    box: "Sleeve 50 pcs",
    price: 1000,
    capacity: 350,
    material: "plastik"
  },

  # Kantong Plastik
  {
    name: "Kantong Plastik HDPE 1kg",
    size: "1kg",
    box: "Roll 100 pcs",
    price: 500,
    capacity: 1000,
    material: "plastik"
  },
  {
    name: "Kantong Plastik HDPE 500g",
    size: "500g",
    box: "Roll 100 pcs",
    price: 350,
    capacity: 500,
    material: "plastik"
  },

  # Kemasan Kertas
  {
    name: "Paper Cup 8oz",
    size: "8oz (240ml)",
    box: "Sleeve 50 pcs",
    price: 1200,
    capacity: 240,
    material: "kertas"
  },
  {
    name: "Paper Cup 12oz",
    size: "12oz (350ml)",
    box: "Sleeve 50 pcs",
    price: 1500,
    capacity: 350,
    material: "kertas"
  },
  {
    name: "Paper Bowl 16oz",
    size: "16oz (480ml)",
    box: "Sleeve 25 pcs",
    price: 2000,
    capacity: 480,
    material: "kertas"
  },

  # Kotak Kardus
  {
    name: "Kotak Kardus Food Grade 500ml",
    size: "500ml",
    box: "Bundle 50 pcs",
    price: 1800,
    capacity: 500,
    material: "karton"
  },
  {
    name: "Kotak Kardus Food Grade 1L",
    size: "1 Liter",
    box: "Bundle 25 pcs",
    price: 2800,
    capacity: 1000,
    material: "karton"
  },

  # Aluminium Container
  {
    name: "Aluminium Tray 650ml",
    size: "650ml",
    box: "Sleeve 25 pcs",
    price: 2500,
    capacity: 650,
    material: "aluminium"
  },
  {
    name: "Aluminium Tray 1L",
    size: "1 Liter",
    box: "Sleeve 25 pcs",
    price: 3200,
    capacity: 1000,
    material: "aluminium"
  },

  # Jar Kaca
  {
    name: "Jar Kaca 250ml",
    size: "250ml",
    box: "Kardus 24 pcs",
    price: 4500,
    capacity: 250,
    material: "kaca"
  },
  {
    name: "Jar Kaca 500ml",
    size: "500ml",
    box: "Kardus 12 pcs",
    price: 6500,
    capacity: 500,
    material: "kaca"
  },

  # Bio-degradable
  {
    name: "Kompostable Cup 350ml",
    size: "350ml (12oz)",
    box: "Sleeve 50 pcs",
    price: 2200,
    capacity: 350,
    material: "bio_degradable"
  },
  {
    name: "Kompostable Food Box 750ml",
    size: "750ml",
    box: "Bundle 25 pcs",
    price: 3800,
    capacity: 750,
    material: "bio_degradable"
  },

  # Kaleng
  {
    name: "Kaleng Aluminium 330ml",
    size: "330ml",
    box: "Shrink 24 pcs",
    price: 3000,
    capacity: 330,
    material: "logam"
  },
  {
    name: "Kaleng Aluminium 500ml",
    size: "500ml",
    box: "Shrink 24 pcs",
    price: 4200,
    capacity: 500,
    material: "logam"
  }
]

packaging_data.each do |pack_data|
  Packaging.create!(pack_data)
end

puts "Seed data created successfully!"
puts "#{Person.count} people created"
puts "#{Packaging.count} packaging created"
# puts "#{Ingredient.count} ingredients created"
# puts "#{Recipe.count} recipes created"
# puts "#{Product.count} products created"
