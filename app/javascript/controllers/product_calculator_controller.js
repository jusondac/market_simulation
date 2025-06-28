import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.recipesData = JSON.parse(document.getElementById('recipes-data').textContent)
    this.recipeCounter = 0
    this.updateCost()
  }

  toggleRecipeMode(event) {
    const mode = event.target.value
    const singleSection = document.getElementById('single-recipe-section')
    const multipleSection = document.getElementById('multiple-recipes-section')

    if (mode === 'single') {
      singleSection.classList.remove('hidden')
      multipleSection.classList.add('hidden')
      this.updateCost()
    } else {
      singleSection.classList.add('hidden')
      multipleSection.classList.remove('hidden')
      this.updateMultipleRecipeCost()
    }
  }

  addRecipe() {
    const container = document.getElementById('product-recipes-container')
    const template = document.getElementById('recipe-form-template')
    const newRecipe = template.content.cloneNode(true)

    // Replace NEW_RECORD with unique index
    const html = newRecipe.querySelector('.product-recipe-form').outerHTML
    const updatedHtml = html.replace(/NEW_RECORD/g, Date.now() + this.recipeCounter++)

    container.insertAdjacentHTML('beforeend', updatedHtml)
    this.updateMultipleRecipeCost()
  }

  removeRecipe(event) {
    const recipeForm = event.target.closest('.product-recipe-form')
    recipeForm.remove()
    this.updateMultipleRecipeCost()
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
    document.getElementById('recipe-cost').textContent = `Rp ${recipe.cost_per_serving.toLocaleString('id-ID')}`
    document.getElementById('servings-count').textContent = recipe.servings
    document.getElementById('product-cost').textContent = `Rp ${recipe.total_cost.toLocaleString('id-ID')}`

    // Update ingredients preview
    this.updateIngredientsPreview(recipe)

    // Update price calculation
    this.updatePrice()
  }

  updateMultipleRecipeCost() {
    const recipeForms = document.querySelectorAll('.product-recipe-form')
    let totalCost = 0
    let hasValidRecipes = false

    recipeForms.forEach(form => {
      const recipeSelect = form.querySelector('select[name*="recipe_id"]')
      const quantityInput = form.querySelector('input[name*="quantity"]')
      const recipeCostDisplay = form.querySelector('.recipe-cost-display')
      const recipeTotalCostDisplay = form.querySelector('.recipe-total-cost-display')

      const selectedRecipeId = recipeSelect?.value
      const quantity = parseFloat(quantityInput?.value) || 0

      if (selectedRecipeId && quantity > 0) {
        const recipe = this.recipesData.find(r => r.id == selectedRecipeId)
        if (recipe) {
          const recipeCost = recipe.total_cost
          const recipeTotal = recipeCost * quantity

          recipeCostDisplay.textContent = `Rp ${recipeCost.toLocaleString('id-ID')}`
          recipeTotalCostDisplay.textContent = `Rp ${recipeTotal.toLocaleString('id-ID')}`

          totalCost += recipeTotal
          hasValidRecipes = true
        }
      } else {
        recipeCostDisplay.textContent = '-'
        recipeTotalCostDisplay.textContent = '-'
      }
    })

    if (hasValidRecipes) {
      document.getElementById('recipe-cost').textContent = 'Multiple recipes'
      document.getElementById('servings-count').textContent = '1 product'
      document.getElementById('product-cost').textContent = `Rp ${totalCost.toLocaleString('id-ID')}`
      this.updatePriceForMultiple(totalCost)
    } else {
      this.clearCalculator()
    }
  }

  updatePriceForMultiple(totalCost) {
    const marginInput = this.element.querySelector('input[name*="margin"]')
    const margin = parseFloat(marginInput?.value) || 0

    const sellingPrice = totalCost * (1 + margin / 100)
    const profit = sellingPrice - totalCost

    document.getElementById('margin-display').textContent = `${margin}%`
    document.getElementById('selling-price').textContent = `Rp ${sellingPrice.toLocaleString('id-ID')}`
    document.getElementById('profit-per-unit').textContent = `Rp ${profit.toLocaleString('id-ID')}`
  }

  updatePrice() {
    const mode = document.querySelector('input[name="recipe_mode"]:checked')?.value

    if (mode === 'multiple') {
      this.updateMultipleRecipeCost()
      return
    }

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
    document.getElementById('selling-price').textContent = `Rp ${sellingPrice.toLocaleString('id-ID')}`
    document.getElementById('profit-per-unit').textContent = `Rp ${profit.toLocaleString('id-ID')}`
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
          <span class="font-medium">Rp ${ingredient.cost.toLocaleString('id-ID')}</span>
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
