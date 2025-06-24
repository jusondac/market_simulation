# Ransack configuration
Ransack.configure do |config|
  # Hide the search form fields from error messages
  config.hide_sort_order_indicators = true
  
  # Add authorization (if needed)
  # config.auth_scope = :admin
  
  # Custom predicates (if needed)
  # config.add_predicate :equals_any,
  #   arel_predicate: 'in',
  #   formatter: proc { |v| v.split(',').map(&:strip) }
end
