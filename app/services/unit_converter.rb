class UnitConverter
  # Unit conversions to grams (base unit)
  CONVERSIONS = {
    # Volume to weight conversions (approximate, varies by ingredient)
    "cup" => { water: 240, flour: 120, sugar: 200, butter: 227, oil: 218 },
    "tbsp" => { water: 15, flour: 7.5, sugar: 12.5, butter: 14.2, oil: 13.6 },
    "tablespoon" => { water: 15, flour: 7.5, sugar: 12.5, butter: 14.2, oil: 13.6 },
    "tsp" => { water: 5, flour: 2.5, sugar: 4.2, butter: 4.7, oil: 4.5 },
    "teaspoon" => { water: 5, flour: 2.5, sugar: 4.2, butter: 4.7, oil: 4.5 },

    # Weight conversions
    "g" => 1,
    "gram" => 1,
    "kg" => 1000,
    "kilogram" => 1000,
    "lb" => 453.592,
    "pound" => 453.592,
    "oz" => 28.3495,
    "ounce" => 28.3495,

    # Count (no conversion)
    "piece" => 1,
    "pieces" => 1,
    "item" => 1,
    "items" => 1,
    "package" => 1,
    "packages" => 1
  }.freeze

  # Default ingredient type for volume conversions
  DEFAULT_INGREDIENT_TYPE = :flour

  def self.convert_to_grams(quantity, from_unit, ingredient_type = nil)
    from_unit = from_unit.to_s.downcase.strip

    return quantity if from_unit == "g" || from_unit == "gram"

    conversion = CONVERSIONS[from_unit]
    return quantity unless conversion

    if conversion.is_a?(Hash)
      # Volume conversion - depends on ingredient type
      ingredient_key = ingredient_type&.to_sym || DEFAULT_INGREDIENT_TYPE
      ingredient_key = DEFAULT_INGREDIENT_TYPE unless conversion.key?(ingredient_key)
      quantity * conversion[ingredient_key]
    else
      # Direct weight conversion
      quantity * conversion
    end
  end

  def self.convert_from_grams(quantity_in_grams, to_unit, ingredient_type = nil)
    to_unit = to_unit.to_s.downcase.strip

    return quantity_in_grams if to_unit == "g" || to_unit == "gram"

    conversion = CONVERSIONS[to_unit]
    return quantity_in_grams unless conversion

    if conversion.is_a?(Hash)
      # Volume conversion - depends on ingredient type
      ingredient_key = ingredient_type&.to_sym || DEFAULT_INGREDIENT_TYPE
      ingredient_key = DEFAULT_INGREDIENT_TYPE unless conversion.key?(ingredient_key)
      quantity_in_grams / conversion[ingredient_key]
    else
      # Direct weight conversion
      quantity_in_grams / conversion
    end
  end

  def self.supported_units
    CONVERSIONS.keys + [ "ml", "milliliter", "l", "liter" ]
  end

  def self.volume_units
    CONVERSIONS.select { |_, v| v.is_a?(Hash) }.keys
  end

  def self.weight_units
    CONVERSIONS.select { |_, v| v.is_a?(Numeric) }.keys + [ "g", "gram" ]
  end

  def self.count_units
    [ "piece", "pieces", "item", "items", "package", "packages" ]
  end
end
