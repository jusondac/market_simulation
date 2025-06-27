import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fromQuantity", "fromUnit", "toQuantity", "toUnit", "ingredientType", "ingredientTypeContainer", "result"]

  connect() {
    this.conversions = {
      // Volume to weight conversions (approximate, varies by ingredient)
      "cup": { water: 240, flour: 120, sugar: 200, butter: 227, oil: 218 },
      "tbsp": { water: 15, flour: 7.5, sugar: 12.5, butter: 14.2, oil: 13.6 },
      "tsp": { water: 5, flour: 2.5, sugar: 4.2, butter: 4.7, oil: 4.5 },

      // Weight conversions to grams
      "g": 1,
      "kg": 1000,
      "lb": 453.592,
      "oz": 28.3495,

      // Count (no conversion)
      "piece": 1,
      "package": 1
    }

    this.volumeUnits = ["cup", "tbsp", "tsp"]

    // Set up event listeners
    this.fromUnitTarget.addEventListener('change', () => this.fromUnitChanged())
  }

  fromUnitChanged() {
    const fromUnit = this.fromUnitTarget.value

    // Show ingredient type selector for volume units
    if (this.volumeUnits.includes(fromUnit)) {
      this.ingredientTypeContainerTarget.classList.remove('hidden')
    } else {
      this.ingredientTypeContainerTarget.classList.add('hidden')
    }

    this.convert()
  }

  convert() {
    const fromQuantity = parseFloat(this.fromQuantityTarget.value)
    const fromUnit = this.fromUnitTarget.value
    const toUnit = this.toUnitTarget.value
    const ingredientType = this.ingredientTypeTarget.value

    // Clear result if inputs are invalid
    if (!fromQuantity || !fromUnit || !toUnit) {
      this.clearResult()
      return
    }

    // Convert from source unit to grams first
    const grams = this.convertToGrams(fromQuantity, fromUnit, ingredientType)

    // Convert from grams to target unit
    const result = this.convertFromGrams(grams, toUnit, ingredientType)

    // Display result
    this.toQuantityTarget.value = result.toFixed(3)
    this.showResult(fromQuantity, fromUnit, result, toUnit, ingredientType)
  }

  convertToGrams(quantity, fromUnit, ingredientType = 'flour') {
    const conversion = this.conversions[fromUnit]

    if (!conversion) return quantity

    if (typeof conversion === 'object') {
      // Volume conversion - depends on ingredient type
      return quantity * (conversion[ingredientType] || conversion.flour)
    } else {
      // Direct weight conversion
      return quantity * conversion
    }
  }

  convertFromGrams(grams, toUnit, ingredientType = 'flour') {
    if (toUnit === 'g') return grams

    const conversion = this.conversions[toUnit]

    if (!conversion) return grams

    if (typeof conversion === 'object') {
      // Volume conversion - depends on ingredient type
      return grams / (conversion[ingredientType] || conversion.flour)
    } else {
      // Direct weight conversion
      return grams / conversion
    }
  }

  showResult(fromQuantity, fromUnit, toQuantity, toUnit, ingredientType) {
    const unitNames = {
      'g': 'gram',
      'kg': 'kilogram',
      'lb': 'pound',
      'oz': 'ons',
      'cup': 'cangkir',
      'tbsp': 'sendok makan',
      'tsp': 'sendok teh',
      'piece': 'buah',
      'package': 'kemasan'
    }

    const ingredientNames = {
      'flour': 'tepung',
      'sugar': 'gula',
      'butter': 'mentega',
      'oil': 'minyak',
      'water': 'air'
    }

    let resultHTML = `
      <div class="text-center">
        <div class="text-2xl font-bold text-indigo-400 mb-2">
          ${fromQuantity} ${unitNames[fromUnit] || fromUnit} = ${toQuantity.toFixed(3)} ${unitNames[toUnit] || toUnit}
        </div>
    `

    // Show ingredient type info for volume conversions
    if (this.volumeUnits.includes(fromUnit) || this.volumeUnits.includes(toUnit)) {
      resultHTML += `
        <div class="text-sm text-gray-400 mb-2">
          *Berdasarkan jenis bahan: ${ingredientNames[ingredientType] || ingredientType}
        </div>
      `
    }

    // Show gram equivalent
    const grams = this.convertToGrams(fromQuantity, fromUnit, ingredientType)
    if (fromUnit !== 'g' && toUnit !== 'g') {
      resultHTML += `
        <div class="text-sm text-gray-500">
          (setara dengan ${grams.toFixed(2)} gram)
        </div>
      `
    }

    resultHTML += `
      </div>
    `

    this.resultTarget.innerHTML = resultHTML
  }

  clearResult() {
    this.toQuantityTarget.value = ''
    this.resultTarget.innerHTML = `
      <div class="text-center text-gray-400">
        <svg class="w-8 h-8 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z"></path>
        </svg>
        <p>Masukkan nilai untuk melihat hasil konversi</p>
      </div>
    `
  }
}
