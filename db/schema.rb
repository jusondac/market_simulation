# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_27_202554) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "ingredient_types", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.string "unit"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ingredient_code"
    t.string "ingredient_type"
    t.index ["ingredient_code"], name: "index_ingredients_on_ingredient_code", unique: true
  end

  create_table "market_simulations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "classification"
    t.text "taste_preferences"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "name"
    t.decimal "price"
    t.decimal "margin"
    t.decimal "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_products_on_recipe_id"
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "ingredient_id", null: false
    t.decimal "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "instructions"
    t.integer "servings"
    t.integer "preparation_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "simulation_products", force: :cascade do |t|
    t.bigint "market_simulation_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["market_simulation_id"], name: "index_simulation_products_on_market_simulation_id"
    t.index ["product_id"], name: "index_simulation_products_on_product_id"
  end

  create_table "simulation_results", force: :cascade do |t|
    t.bigint "market_simulation_id", null: false
    t.bigint "person_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity_sold"
    t.decimal "total_revenue"
    t.decimal "profit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["market_simulation_id"], name: "index_simulation_results_on_market_simulation_id"
    t.index ["person_id"], name: "index_simulation_results_on_person_id"
    t.index ["product_id"], name: "index_simulation_results_on_product_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "products", "recipes"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "simulation_products", "market_simulations"
  add_foreign_key "simulation_products", "products"
  add_foreign_key "simulation_results", "market_simulations"
  add_foreign_key "simulation_results", "people"
  add_foreign_key "simulation_results", "products"
end
