import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  connect() {
    this.boundClickOutside = this.clickOutside.bind(this)
    this.boundEscape = this.handleEscape.bind(this)
  }

  disconnect() {
    document.removeEventListener("click", this.boundClickOutside)
    document.removeEventListener("keydown", this.boundEscape)
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    if (this.menuTarget.classList.contains("hidden")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.menuTarget.classList.remove("hidden")
    this.buttonTarget.setAttribute("aria-expanded", "true")
    document.addEventListener("click", this.boundClickOutside)
    document.addEventListener("keydown", this.boundEscape)
  }

  close() {
    this.menuTarget.classList.add("hidden")
    this.buttonTarget.setAttribute("aria-expanded", "false")
    document.removeEventListener("click", this.boundClickOutside)
    document.removeEventListener("keydown", this.boundEscape)
  }

  clickOutside(event) {
    if (!this.element.contains(event.target)) this.close()
  }

  handleEscape(event) {
    if (event.key === "Escape") this.close()
  }
}
