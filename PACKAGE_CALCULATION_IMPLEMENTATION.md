# Ingredient Package Cost Calculation Implementation

## Overview
This implementation adds support for package-based ingredient cost calculation where ingredients of type "kemasan" (package) have their costs calculated based on the package size and unit price per package content.

## Example Scenario
- Ingredient: Basreng (snack)
- Type: kemasan (package)
- Package price: Rp 10,000 per package
- Package contains: 10 pieces
- Recipe requires: 1 piece
- **Calculated cost**: Rp 10,000 ÷ 10 = Rp 1,000

## Database Structure Changes

### New Tables
1. **ingredient_details** - Stores package information
   - `ingredient_id` (references ingredients)
   - `package_size` (decimal) - Amount contained in package
   - `package_unit` (string) - Unit of package content

### Removed Fields
- Removed `package_size` and `package_unit` from `ingredients` table
- Data now stored in separate `ingredient_details` table

## Model Changes

### Ingredient Model
- Added `has_one :ingredient_detail` association
- Added `accepts_nested_attributes_for :ingredient_detail`
- Added delegation methods: `package_size`, `package_unit`
- Added helper methods:
  - `unit_price` - Price per unit (for kemasan type)
  - `effective_unit` - Display unit (package_unit for kemasan, unit for others)
  - `total_recipe_cost` - Sum of all recipe costs using new calculation

### RecipeIngredient Model
- Updated `calculate_cost` method to handle package-based calculation:
  ```ruby
  def calculate_cost
    if ingredient.ingredient_type == 'kemasan' && ingredient.ingredient_detail&.package_size.present?
      cost_per_unit = ingredient.price / ingredient.ingredient_detail.package_size
      cost_per_unit * quantity
    else
      ingredient.price * quantity
    end
  end
  ```

### Recipe Model
- Updated `total_cost` to use `calculate_cost` method

## View Changes

### Forms (New/Edit Ingredient)
- Added nested form fields for `ingredient_detail`
- Package fields only visible when ingredient type is "kemasan"
- JavaScript toggles package fields visibility

### Display Views
- Updated all cost displays to use `calculate_cost`
- Updated unit displays to use `effective_unit`
- Added package information display in ingredient lists and details

### Recipe Views
- Cost breakdowns now use accurate package-based calculations
- Unit displays show effective units (e.g., "gram" instead of "package")

## Controller Changes
- Updated `ingredient_params` to accept nested `ingredient_detail_attributes`
- Added `build_ingredient_detail` in new/edit actions

## Migration Files
1. `CreateIngredientDetails` - Creates ingredient_details table
2. `RemovePackageFieldsFromIngredients` - Removes old package fields
3. `DataCleanupForIngredientDetails` - Ensures data consistency

## Usage Examples

### Regular Ingredient (e.g., Flour)
- Price: Rp 5,000 per kg
- Recipe needs: 0.5 kg
- Cost calculation: Rp 5,000 × 0.5 = Rp 2,500

### Package Ingredient (e.g., Basreng)
- Price: Rp 10,000 per package
- Package contains: 10 pieces
- Recipe needs: 3 pieces
- Cost calculation: (Rp 10,000 ÷ 10) × 3 = Rp 3,000

## Benefits
1. **Accurate Costing**: Proper cost calculation for packaged ingredients
2. **Better UX**: Clear display of package vs unit pricing
3. **Flexible**: Supports both regular and package-based ingredients
4. **Maintainable**: Clean separation of concerns with ingredient_details table

## Testing
After running migrations, test by:
1. Creating a "kemasan" type ingredient with package details
2. Adding it to a recipe
3. Verifying cost calculations are correct
4. Checking that displays show proper units and prices
