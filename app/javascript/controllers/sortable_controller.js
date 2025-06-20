import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["item"]

  connect() {
    this.sortable = Sortable.create(this.element, {
      handle: '.drag-handle',
      animation: 150,
      ghostClass: 'sortable-ghost',
      chosenClass: 'sortable-chosen',
      dragClass: 'sortable-drag',
      onEnd: this.end.bind(this)
    })
  }

  disconnect() {
    if (this.sortable) {
      this.sortable.destroy()
    }
  }

  end(event) {
    // Update hidden inputs or trigger form submission
    this.updateOrder()
  }

  updateOrder() {
    this.itemTargets.forEach((item, index) => {
      const orderInput = item.querySelector('input[name*="[position]"]')
      if (orderInput) {
        orderInput.value = index
      }
    })
  }
}
