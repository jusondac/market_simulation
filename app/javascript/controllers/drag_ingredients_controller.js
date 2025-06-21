import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "item"]

  connect() {
    this.setupDragAndDrop()
  }

  setupDragAndDrop() {
    if (this.hasContainerTarget) {
      this.containerTarget.addEventListener('dragover', this.handleDragOver.bind(this))
      this.containerTarget.addEventListener('drop', this.handleDrop.bind(this))

      this.itemTargets.forEach(item => {
        this.setupItemDragAndDrop(item)
      })
    }
  }

  setupItemDragAndDrop(item) {
    item.addEventListener('dragstart', this.handleDragStart.bind(this))
    item.addEventListener('dragend', this.handleDragEnd.bind(this))
    item.draggable = true
  }

  handleDragStart(event) {
    this.draggedElement = event.target.closest('[data-drag-ingredients-target="item"]')
    this.draggedElement.classList.add('opacity-50', 'scale-95')
    event.dataTransfer.effectAllowed = 'move'
    event.dataTransfer.setData('text/html', this.draggedElement.outerHTML)
  }

  handleDragEnd(event) {
    if (this.draggedElement) {
      this.draggedElement.classList.remove('opacity-50', 'scale-95')
      this.draggedElement = null
    }
  }

  handleDragOver(event) {
    event.preventDefault()
    event.dataTransfer.dropEffect = 'move'

    const afterElement = this.getDragAfterElement(this.containerTarget, event.clientY)
    if (afterElement == null) {
      this.containerTarget.appendChild(this.draggedElement)
    } else {
      this.containerTarget.insertBefore(this.draggedElement, afterElement)
    }
  }

  handleDrop(event) {
    event.preventDefault()
    this.updateIngredientOrder()
  }

  getDragAfterElement(container, y) {
    const draggableElements = [...container.querySelectorAll('[data-drag-ingredients-target="item"]:not(.opacity-50)')]

    return draggableElements.reduce((closest, child) => {
      const box = child.getBoundingClientRect()
      const offset = y - box.top - box.height / 2

      if (offset < 0 && offset > closest.offset) {
        return { offset: offset, element: child }
      } else {
        return closest
      }
    }, { offset: Number.NEGATIVE_INFINITY }).element
  }

  updateIngredientOrder() {
    // Update any hidden position fields if they exist
    this.itemTargets.forEach((item, index) => {
      const positionField = item.querySelector('input[name*="[position]"]')
      if (positionField) {
        positionField.value = index
      }
    })

    // Trigger any necessary form updates
    this.dispatch('reordered', { detail: { items: this.itemTargets } })
  }

  // Method to add new item from external source
  addItem(itemData) {
    const newItem = this.createItemElement(itemData)
    this.containerTarget.appendChild(newItem)
    this.setupItemDragAndDrop(newItem)
    this.updateIngredientOrder()
  }

  createItemElement(data) {
    const div = document.createElement('div')
    div.setAttribute('data-drag-ingredients-target', 'item')
    div.className = 'nested-fields bg-gray-900 rounded-lg p-4 border border-gray-700 transition-all duration-200'

    div.innerHTML = `
      <div class="flex items-center space-x-3">
        <div class="drag-handle cursor-move text-gray-400 hover:text-gray-300">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8h16M4 16h16"></path>
          </svg>
        </div>
        <div class="flex-1 grid grid-cols-1 md:grid-cols-2 gap-3">
          <div>
            <label class="block text-sm font-medium text-gray-300">Bahan</label>
            <select name="recipe[recipe_ingredients_attributes][${Date.now()}][ingredient_id]" 
                    class="block w-full rounded-md border-gray-600 bg-gray-700 text-gray-100 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm px-3 py-2">
              <option value="">Pilih bahan</option>
              ${this.getIngredientOptions(data.ingredient_id)}
            </select>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-300">Jumlah</label>
            <input type="number" step="0.01" 
                   name="recipe[recipe_ingredients_attributes][${Date.now()}][quantity]" 
                   value="${data.quantity || ''}"
                   class="block w-full rounded-md border-gray-600 bg-gray-700 text-gray-100 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm px-3 py-2 placeholder-gray-400" 
                   placeholder="1.5">
          </div>
        </div>
        <button type="button" 
                data-action="click->drag-ingredients#removeItem" 
                class="text-red-500 hover:text-red-700 p-1">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
        <input type="hidden" name="recipe[recipe_ingredients_attributes][${Date.now()}][_destroy]" value="0">
      </div>
    `

    return div
  }

  getIngredientOptions(selectedId = null) {
    // This would need to be populated with available ingredients
    // For now, return empty - this should be populated from the controller
    return ''
  }

  removeItem(event) {
    const item = event.target.closest('[data-drag-ingredients-target="item"]')
    if (item) {
      // Mark for destruction if it's an existing record
      const destroyField = item.querySelector('input[name*="[_destroy]"]')
      if (destroyField) {
        destroyField.value = '1'
        item.style.display = 'none'
      } else {
        item.remove()
      }
      this.updateIngredientOrder()
    }
  }

  // Unit conversion feature
  convertUnit(event) {
    const item = event.target.closest('[data-drag-ingredients-target="item"]')
    const quantityInput = item.querySelector('input[name*="[quantity]"]')
    const ingredientSelect = item.querySelector('select[name*="[ingredient_id]"]')

    if (quantityInput && ingredientSelect.value) {
      // Get ingredient unit and current quantity
      const currentQuantity = parseFloat(quantityInput.value)
      const ingredientOption = ingredientSelect.selectedOptions[0]
      const currentUnit = ingredientOption.dataset.unit

      if (currentQuantity && currentUnit) {
        // Show conversion modal or inline converter
        this.showUnitConverter(item, currentQuantity, currentUnit)
      }
    }
  }

  showUnitConverter(item, quantity, unit) {
    // Create conversion popup
    const modal = document.createElement('div')
    modal.className = 'fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50'
    modal.innerHTML = `
      <div class="bg-gray-800 rounded-lg p-6 max-w-md w-full mx-4">
        <h3 class="text-lg font-semibold text-gray-100 mb-4">Konversi Satuan</h3>
        <div class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-300 mb-1">Dari</label>
            <div class="flex space-x-2">
              <input type="number" value="${quantity}" class="flex-1 rounded-md border-gray-600 bg-gray-700 text-gray-100 px-3 py-2" id="from-quantity">
              <select class="rounded-md border-gray-600 bg-gray-700 text-gray-100 px-3 py-2" id="from-unit">
                <option value="${unit}" selected>${unit}</option>
                ${this.getUnitOptions()}
              </select>
            </div>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-300 mb-1">Ke</label>
            <div class="flex space-x-2">
              <input type="number" readonly class="flex-1 rounded-md border-gray-600 bg-gray-700 text-gray-100 px-3 py-2" id="to-quantity">
              <select class="rounded-md border-gray-600 bg-gray-700 text-gray-100 px-3 py-2" id="to-unit">
                ${this.getUnitOptions()}
              </select>
            </div>
          </div>
          <div class="flex justify-end space-x-2 pt-4">
            <button type="button" class="px-4 py-2 bg-gray-600 text-white rounded-md hover:bg-gray-700" onclick="this.closest('.fixed').remove()">Batal</button>
            <button type="button" class="px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700" onclick="this.closest('[data-controller]').applyConversion()">Terapkan</button>
          </div>
        </div>
      </div>
    `

    document.body.appendChild(modal)

    // Add conversion logic
    const fromQuantityInput = modal.querySelector('#from-quantity')
    const fromUnitSelect = modal.querySelector('#from-unit')
    const toQuantityInput = modal.querySelector('#to-quantity')
    const toUnitSelect = modal.querySelector('#to-unit')

    const updateConversion = () => {
      // This would use the UnitConverter service
      // For now, just show the same value
      toQuantityInput.value = fromQuantityInput.value
    }

    fromQuantityInput.addEventListener('input', updateConversion)
    fromUnitSelect.addEventListener('change', updateConversion)
    toUnitSelect.addEventListener('change', updateConversion)

    updateConversion()
  }

  getUnitOptions() {
    return `
      <option value="gram">Gram</option>
      <option value="kg">Kilogram</option>
      <option value="cup">Cangkir</option>
      <option value="tbsp">Sendok Makan</option>
      <option value="tsp">Sendok Teh</option>
      <option value="lb">Pon</option>
      <option value="oz">Ons</option>
      <option value="piece">Buah</option>
    `
  }
}
