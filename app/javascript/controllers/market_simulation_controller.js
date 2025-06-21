import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["productItem"]

  connect() {
    this.updateSimulationSummary()
  }

  toggleProduct(event) {
    const checkbox = event.target
    const productItem = checkbox.closest('[data-market-simulation-target="productItem"]')
    const controls = productItem.querySelector('.product-controls')
    
    if (checkbox.checked) {
      controls.style.display = 'grid'
    } else {
      controls.style.display = 'none'
    }
    
    this.updateSimulationSummary()
  }

  updateSimulationSummary() {
    const selectedProducts = this.element.querySelectorAll('input[name="product_ids[]"]:checked')
    const summaryContainer = document.getElementById('simulation-summary')
    
    if (selectedProducts.length === 0) {
      summaryContainer.innerHTML = '<div class="text-sm text-gray-500">Select products to see simulation preview</div>'
      return
    }
    
    let totalQuantity = 0
    let totalRevenue = 0
    let totalProfit = 0
    
    const productSummaries = Array.from(selectedProducts).map(checkbox => {
      const productId = checkbox.value
      const productItem = checkbox.closest('[data-market-simulation-target="productItem"]')
      const productName = productItem.querySelector('h3').textContent
      const quantityInput = productItem.querySelector(`input[name="quantity_${productId}"]`)
      const priceInput = productItem.querySelector(`input[name="price_${productId}"]`)
      
      const quantity = parseInt(quantityInput?.value) || 0
      const price = parseFloat(priceInput?.value) || 0
      
      // Estimate cost from the product display (this is approximate)
      const profitText = productItem.querySelector('.text-gray-500').textContent
      const profitMatch = profitText.match(/\$([0-9.]+) profit\/unit/)
      const profitPerUnit = profitMatch ? parseFloat(profitMatch[1]) : 0
      
      const revenue = quantity * price
      const profit = quantity * profitPerUnit
      
      totalQuantity += quantity
      totalRevenue += revenue
      totalProfit += profit
      
      return { name: productName, quantity, price, revenue, profit }
    })
    
    let summaryHTML = '<div class="space-y-3">'
    
    productSummaries.forEach(product => {
      summaryHTML += `
        <div class="flex justify-between text-sm">
          <span class="text-gray-600">${product.name}:</span>
          <span class="font-medium">${product.quantity} units</span>
        </div>
      `
    })
    
    summaryHTML += `
      <div class="pt-2 border-t border-gray-200 space-y-1">
        <div class="flex justify-between text-sm">
          <span class="text-gray-900 font-medium">Total Units:</span>
          <span class="font-bold">${totalQuantity}</span>
        </div>
        <div class="flex justify-between text-sm">
          <span class="text-gray-900 font-medium">Potential Revenue:</span>
          <span class="font-bold text-green-600">$${totalRevenue.toFixed(2)}</span>
        </div>
        <div class="flex justify-between text-sm">
          <span class="text-gray-900 font-medium">Potential Profit:</span>
          <span class="font-bold text-green-600">$${totalProfit.toFixed(2)}</span>
        </div>
      </div>
    </div>`
    
    summaryContainer.innerHTML = summaryHTML
  }
}
