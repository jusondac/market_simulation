import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container"]

  add(event) {
    event.preventDefault()

    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, Date.now())
    this.containerTarget.insertAdjacentHTML('beforeend', content)
  }

  remove(event) {
    event.preventDefault()

    const item = event.target.closest('.nested-fields')
    if (item) {
      const destroyInput = item.querySelector('input[name*="_destroy"]')
      if (destroyInput) {
        destroyInput.value = '1'
        item.style.display = 'none'
      } else {
        item.remove()
      }
    }
  }
}
