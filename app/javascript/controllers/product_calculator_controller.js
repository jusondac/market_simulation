import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.recipesData = JSON.parse(document.getElementById('recipes-data').textContent)
    this.updateCost()
  }

  updateCost() {
    const recipeSelect = this.element.querySelector('select[name*="recipe_id"]')
    const selectedRecipeId = recipeSelect?.value
    
    if (!selectedRecipeId) {
      this.clearCalculator()
      return
    }

    const recipe = this.recipesData.find(r => r.id == selectedRecipeId)
    if (!recipe) return

    // Update recipe info
    document.getElementById('recipe-cost').textContent = `$${recipe.cost_per_serving.toFixed(2)}`
    document.getElementById('servings-count').textContent = recipe.servings
    document.getElementById('product-cost').textContent = `$${recipe.total_cost.toFixed(2)}`

    // Update ingredients preview
    this.updateIngredientsPreview(recipe)
    
    // Update price calculation
    this.updatePrice()
  }

  updatePrice() {
    const recipeSelect = this.element.querySelector('select[name*="recipe_id"]')
    const marginInput = this.element.querySelector('input[name*="margin"]')
    
    const selectedRecipeId = recipeSelect?.value
    const margin = parseFloat(marginInput?.value) || 0

    if (!selectedRecipeId) return

    const recipe = this.recipesData.find(r => r.id == selectedRecipeId)
    if (!recipe) return

    const cost = recipe.total_cost
    const sellingPrice = cost * (1 + margin / 100)
    const profit = sellingPrice - cost

    document.getElementById('margin-display').textContent = `${margin}%`
    document.getElementById('selling-price').textContent = `$${sellingPrice.toFixed(2)}`
    document.getElementById('profit-per-unit').textContent = `$${profit.toFixed(2)}`
  }

  updateIngredientsPreview(recipe) {
    const ingredientsList = document.getElementById('ingredients-list')
    const recipePreview = document.getElementById('recipe-preview')
    
    if (recipe.ingredients && recipe.ingredients.length > 0) {
      ingredientsList.innerHTML = recipe.ingredients.map(ingredient => `
        <div class="flex justify-between items-center p-3 bg-white rounded border">
          <div>
            <span class="font-medium">${ingredient.name}</span>
            <div class="text-sm text-gray-500">${ingredient.quantity} ${ingredient.unit}</div>
          </div>
          <span class="font-medium">$${ingredient.cost.toFixed(2)}</span>
        </div>
      `).join('')
      
      recipePreview.classList.remove('hidden')
    } else {
      recipePreview.classList.add('hidden')
    }
  }

  clearCalculator() {
    document.getElementById('recipe-cost').textContent = '-'
    document.getElementById('servings-count').textContent = '-'
    document.getElementById('product-cost').textContent = '-'
    document.getElementById('margin-display').textContent = '-'
    document.getElementById('selling-price').textContent = '-'
    document.getElementById('profit-per-unit').textContent = '-'
    document.getElementById('recipe-preview').classList.add('hidden')
  }
}
