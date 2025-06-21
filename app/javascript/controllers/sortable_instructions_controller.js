import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "item", "textarea"]

  connect() {
    this.setupSortable()
    this.updateNumbering()
  }

  setupSortable() {
    if (this.hasContainerTarget) {
      // Enable drag and drop functionality
      this.containerTarget.addEventListener('dragover', this.handleDragOver.bind(this))
      this.containerTarget.addEventListener('drop', this.handleDrop.bind(this))

      this.itemTargets.forEach(item => {
        item.addEventListener('dragstart', this.handleDragStart.bind(this))
        item.addEventListener('dragend', this.handleDragEnd.bind(this))
      })
    }
  }

  handleDragStart(event) {
    this.draggedElement = event.target.closest('[data-sortable-instructions-target="item"]')
    this.draggedElement.classList.add('opacity-50')
    event.dataTransfer.effectAllowed = 'move'
    event.dataTransfer.setData('text/html', this.draggedElement.outerHTML)
  }

  handleDragEnd(event) {
    if (this.draggedElement) {
      this.draggedElement.classList.remove('opacity-50')
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
    this.updateNumbering()
    this.updateTextareaValue()
  }

  getDragAfterElement(container, y) {
    const draggableElements = [...container.querySelectorAll('[data-sortable-instructions-target="item"]:not(.opacity-50)')]

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

  addStep() {
    const newStep = this.createStepElement("")
    this.containerTarget.appendChild(newStep)
    this.updateNumbering()
    this.updateTextareaValue()

    // Focus on the new step's input
    const input = newStep.querySelector('input')
    if (input) input.focus()
  }

  removeStep(event) {
    const step = event.target.closest('[data-sortable-instructions-target="item"]')
    if (step && this.itemTargets.length > 1) {
      step.remove()
      this.updateNumbering()
      this.updateTextareaValue()
    }
  }

  updateStep() {
    this.updateTextareaValue()
  }

  createStepElement(content) {
    const div = document.createElement('div')
    div.setAttribute('data-sortable-instructions-target', 'item')
    div.setAttribute('draggable', 'true')
    div.className = 'flex items-center space-x-3 p-3 bg-gray-900 rounded-lg border border-gray-700 cursor-move'

    div.innerHTML = `
      <div class="flex-shrink-0 w-8 h-8 bg-indigo-600 rounded-full flex items-center justify-center">
        <span class="text-white text-sm font-medium step-number">1</span>
      </div>
      <input type="text" 
             value="${content}" 
             placeholder="Masukkan langkah instruksi..."
             class="flex-1 bg-transparent border-none text-gray-100 placeholder-gray-400 focus:outline-none focus:ring-0"
             data-action="input->sortable-instructions#updateStep">
      <button type="button" 
              class="text-red-400 hover:text-red-300 p-1"
              data-action="click->sortable-instructions#removeStep">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
        </svg>
      </button>
    `

    return div
  }

  updateNumbering() {
    this.itemTargets.forEach((item, index) => {
      const numberElement = item.querySelector('.step-number')
      if (numberElement) {
        numberElement.textContent = (index + 1).toString()
      }
    })
  }

  updateTextareaValue() {
    if (this.hasTextareaTarget) {
      const steps = this.itemTargets.map((item, index) => {
        const input = item.querySelector('input')
        const content = input ? input.value.trim() : ''
        return content
      }).filter(step => step !== '')

      this.textareaTarget.value = steps.join(' - ')
    }
  }

  initializeFromTextarea() {
    if (this.hasTextareaTarget && this.textareaTarget.value.trim()) {
      // Clear existing items
      this.itemTargets.forEach(item => item.remove())

      // Parse textarea content - split by dash separator
      const steps = this.textareaTarget.value.split(' - ')
        .map(step => step.trim())
        .filter(step => step !== '')

      // Create step elements
      steps.forEach(step => {
        const stepElement = this.createStepElement(step)
        this.containerTarget.appendChild(stepElement)
      })

      if (steps.length === 0) {
        this.containerTarget.appendChild(this.createStepElement(""))
      }

      this.updateNumbering()
      this.setupSortable()
    } else if (this.itemTargets.length === 0) {
      // Add first empty step if none exist
      this.containerTarget.appendChild(this.createStepElement(""))
      this.updateNumbering()
      this.setupSortable()
    }
  }
}
