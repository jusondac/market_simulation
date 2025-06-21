import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  quickAdd(event) {
    event.preventDefault()
    
    const ingredientId = event.params.ingredientId
    const ingredientName = event.params.ingredientName
    const ingredientUnit = event.params.ingredientUnit
    
    // Check if this ingredient is already added
    const existingIngredient = this.containerTarget.querySelector(`select[value="${ingredientId}"]`)
    if (existingIngredient) {
      // Focus on the existing ingredient's quantity field
      const quantityInput = existingIngredient.closest('.nested-fields').querySelector('input[name*="quantity"]')
      quantityInput.focus()
      quantityInput.select()
      return
    }
    
    // Generate a unique timestamp for the new record
    const timestamp = Date.now()
    
    // Create the new ingredient field HTML
    const newFieldHTML = `
      <div class="nested-fields bg-gray-50 rounded-lg p-4 border border-gray-200" 
           data-sortable-target="item">
        <div class="flex items-center space-x-3">
          <div class="drag-handle cursor-move text-gray-400 hover:text-gray-600">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8h16M4 16h16"></path>
            </svg>
          </div>
          
          <div class="flex-1 grid grid-cols-1 md:grid-cols-2 gap-3">
            <div>
              <label class="block text-sm font-medium text-gray-700">Ingredient</label>
              <select name="recipe[recipe_ingredients_attributes][${timestamp}][ingredient_id]" 
                      class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm">
                <option value="${ingredientId}" selected>${ingredientName}</option>
              </select>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700">Quantity</label>
              <input type="number" step="0.01" 
                     name="recipe[recipe_ingredients_attributes][${timestamp}][quantity]" 
                     class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm" 
                     placeholder="1.0" value="1.0" autofocus>
            </div>
          </div>
          
          <button type="button" data-action="click->nested-form#remove" 
                  class="text-red-500 hover:text-red-700">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
            </svg>
          </button>
          
          <input type="hidden" name="recipe[recipe_ingredients_attributes][${timestamp}][_destroy]" value="0">
        </div>
      </div>
    `
    
    // Add the new field to the container
    this.containerTarget.insertAdjacentHTML('beforeend', newFieldHTML)
    
    // Focus on the quantity input
    const newField = this.containerTarget.lastElementChild
    const quantityInput = newField.querySelector('input[name*="quantity"]')
    quantityInput.focus()
    quantityInput.select()
    
    // Show success feedback
    event.target.classList.add('bg-green-100', 'text-green-800')
    setTimeout(() => {
      event.target.classList.remove('bg-green-100', 'text-green-800')
    }, 1000)
  }
}
