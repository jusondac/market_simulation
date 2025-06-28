import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["ingredientType", "packageFields"]

  connect() {
    this.togglePackageFields()
  }

  togglePackageFields() {
    if (this.ingredientTypeTarget.value === 'kemasan') {
      this.packageFieldsTarget.classList.remove('hidden')
    } else {
      this.packageFieldsTarget.classList.add('hidden')
    }
  }
}
