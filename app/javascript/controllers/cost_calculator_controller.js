import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["calculator", "item"]

  connect() {
    this.updateCostCalculation()
    this.observeFormChanges()
  }

  itemTargetConnected() {
    this.updateCostCalculation()
  }

  itemTargetDisconnected() {
    this.updateCostCalculation()
  }

  observeFormChanges() {
    // Listen for changes on ingredient and quantity inputs
    this.element.addEventListener('change', (event) => {
      if (event.target.matches('select[name*="ingredient_id"], input[name*="quantity"]')) {
        this.updateCostCalculation()
      }
    })

    this.element.addEventListener('input', (event) => {
      if (event.target.matches('input[name*="quantity"]')) {
        this.updateCostCalculation()
      }
    })
  }

  updateCostCalculation() {
    if (!this.hasCalculatorTarget) return

    const items = this.itemTargets
    const costBreakdown = []
    let totalCost = 0
    let kemasan_cost = 0
    let reguler_cost = 0

    items.forEach(item => {
      const ingredientSelect = item.querySelector('select[name*="ingredient_id"]')
      const quantityInput = item.querySelector('input[name*="quantity"]')

      if (!ingredientSelect || !quantityInput) return

      const ingredientId = ingredientSelect.value
      const quantity = parseFloat(quantityInput.value) || 0

      if (ingredientId && quantity > 0) {
        // Get ingredient data from the select option
        const selectedOption = ingredientSelect.selectedOptions[0]
        if (selectedOption) {
          const ingredientName = selectedOption.textContent
          const ingredientPrice = parseFloat(selectedOption.dataset.price) || 0
          const ingredientType = selectedOption.dataset.type || 'reguler'
          const packageSize = parseFloat(selectedOption.dataset.packageSize) || 1
          const effectiveUnit = selectedOption.dataset.effectiveUnit || selectedOption.dataset.unit || 'unit'

          let itemCost = 0
          if (ingredientType === 'kemasan' && packageSize > 1) {
            itemCost = (ingredientPrice / packageSize) * quantity
            kemasan_cost += itemCost
          } else {
            itemCost = ingredientPrice * quantity
            reguler_cost += itemCost
          }

          costBreakdown.push({
            name: ingredientName,
            quantity: quantity,
            unit: effectiveUnit,
            cost: itemCost,
            type: ingredientType
          })

          totalCost += itemCost
        }
      }
    })

    this.renderCostCalculation(costBreakdown, kemasan_cost, reguler_cost, totalCost)
  }

  renderCostCalculation(breakdown, kemasan_cost, reguler_cost, totalCost) {
    if (breakdown.length === 0) {
      this.calculatorTarget.innerHTML = `
        <div class="text-center text-gray-400 py-4">
          <div class="text-2xl mb-2">💰</div>
          <p class="text-sm">Tambahkan bahan untuk melihat rincian biaya</p>
        </div>
      `
      return
    }

    let html = '<div class="space-y-3">'

    // Individual items
    breakdown.forEach(item => {
      const typeIcon = item.type === 'kemasan' ? '📦' : '🥕'
      const typeColor = item.type === 'kemasan' ? 'text-blue-400' : 'text-green-400'

      html += `
        <div class="flex justify-between items-center text-sm border-b border-gray-700 pb-2">
          <div>
            <div class="text-gray-100">${item.name}</div>
            <div class="text-xs text-gray-400">
              ${item.quantity} ${item.unit}
              <span class="${typeColor} ml-1">${typeIcon}</span>
            </div>
          </div>
          <div class="text-right">
            <div class="font-medium">Rp ${this.formatNumber(item.cost)}</div>
          </div>
        </div>
      `
    })

    // Summary
    html += '<div class="pt-3 border-t border-gray-600 space-y-2">'

    if (kemasan_cost > 0) {
      html += `
        <div class="flex justify-between text-sm">
          <span class="text-blue-400">Biaya bahan kemasan</span>
          <span class="text-blue-400">Rp ${this.formatNumber(kemasan_cost)}</span>
        </div>
      `
    }

    if (reguler_cost > 0) {
      html += `
        <div class="flex justify-between text-sm">
          <span class="text-green-400">Biaya bahan reguler</span>
          <span class="text-green-400">Rp ${this.formatNumber(reguler_cost)}</span>
        </div>
      `
    }

    html += `
        <div class="flex justify-between font-semibold pt-2 border-t border-gray-600">
          <span class="text-gray-400">Total Biaya</span>
          <span class="font-medium">Rp ${this.formatNumber(totalCost)}</span>
        </div>
      </div>
    </div>
    `

    this.calculatorTarget.innerHTML = html
  }

  formatNumber(number) {
    return new Intl.NumberFormat('id-ID').format(Math.round(number))
  }
}
