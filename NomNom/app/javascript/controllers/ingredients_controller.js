import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ingredients"
export default class extends Controller {
  static targets = ["list", "item"]

  add(event) {
    event.preventDefault()
    const template = document.querySelector("#ingredient-template")
    const clone = template.content.cloneNode(true)
    this.listTarget.appendChild(clone)
  }

  remove(event) {
    event.preventDefault()
    const item = event.target.closest("[data-ingredients-target='item']")
    if (item) item.remove()
  }
}
