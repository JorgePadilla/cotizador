import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  submit() {
    // Debounce the search to avoid too many requests
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 300)
  }

  clear() {
    this.element.querySelector('input[name="search"]').value = ''
    this.element.requestSubmit()
  }
}