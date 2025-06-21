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

    // Create the new ingredient field HTML with dark theme
    const newFieldHTML = `
      <div class="nested-fields bg-gray-900 rounded-lg p-4 border border-gray-700" 
           data-drag-ingredients-target="item">
        <div class="flex items-center space-x-3">
          <div class="drag-handle cursor-move text-gray-400 hover:text-gray-300">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8h16M4 16h16"></path>
            </svg>
          </div>
          
          <div class="flex-1 grid grid-cols-1 md:grid-cols-2 gap-3">
            <div>
              <label class="block text-sm font-medium text-gray-300">Bahan</label>
              <select name="recipe[recipe_ingredients_attributes][${timestamp}][ingredient_id]" 
                      class="block w-full rounded-md border-gray-600 bg-gray-700 text-gray-100 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm px-3 py-2">
                <option value="${ingredientId}" selected>${ingredientName}</option>
              </select>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-300">Jumlah</label>
              <input type="number" step="0.01" 
                     name="recipe[recipe_ingredients_attributes][${timestamp}][quantity]" 
                     class="block w-full rounded-md border-gray-600 bg-gray-700 text-gray-100 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm px-3 py-2 placeholder-gray-400" 
                     placeholder="1.0" value="1.0" autofocus>
            </div>
          </div>
          
          <button type="button" data-action="click->drag-ingredients#removeItem" 
                  class="text-red-500 hover:text-red-700 p-1">
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

    // Setup drag and drop for the new item
    const newField = this.containerTarget.lastElementChild
    const dragController = this.application.getControllerForElementAndIdentifier(
      this.containerTarget.closest('[data-controller~="drag-ingredients"]'),
      'drag-ingredients'
    )
    if (dragController) {
      dragController.setupItemDragAndDrop(newField)
    }

    // Focus on the quantity input
    const quantityInput = newField.querySelector('input[name*="quantity"]')
    quantityInput.focus()
    quantityInput.select()

    // Show success feedback with dark theme
    event.target.classList.add('bg-green-900', 'text-green-300')
    setTimeout(() => {
      event.target.classList.remove('bg-green-900', 'text-green-300')
    }, 1000)
  }
}
