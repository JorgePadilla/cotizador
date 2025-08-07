import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["itemsContainer", "subtotal", "tax", "total", "addButton"]
  static values = { defaultTaxPercentage: Number }

  connect() {
    this.updateTotals()
  }

  async addItem(event) {
    event.preventDefault()
    const itemCount = this.itemsContainerTarget.querySelectorAll('.invoice-item-fields').length
    console.log('Adding item with index:', itemCount)
    
    try {
      const response = await fetch(`/invoices/add_item?index=${itemCount}`, {
        method: 'GET',
        headers: {
          'Accept': 'text/vnd.turbo-stream.html',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })
      
      if (response.ok) {
        const turboStreamContent = await response.text()
        Turbo.renderStreamMessage(turboStreamContent)
        // Update totals after adding the item
        this.updateTotals()
      } else {
        console.error('Failed to add item:', response.statusText)
      }
    } catch (error) {
      console.error('Error adding item:', error)
    }
  }

  removeItem(event) {
    event.preventDefault()
    const items = this.itemsContainerTarget.querySelectorAll('.invoice-item-fields')
    
    if (items.length > 1) {
      event.target.closest('.invoice-item-fields').remove()
      this.updateTotals()
    } else {
      alert('At least one item is required.')
    }
  }

  updatePrice(event) {
    const select = event.target
    const option = select.options[select.selectedIndex]
    const price = option.getAttribute('data-price')
    const itemRow = select.closest('.invoice-item-fields')
    const priceInput = itemRow.querySelector('.price-input')
    
    if (price) {
      priceInput.value = price
    } else {
      priceInput.value = ''
    }
    
    this.updateTotals()
  }

  updateTotals() {
    let subtotal = 0
    const items = this.itemsContainerTarget.querySelectorAll('.invoice-item-fields')
    
    items.forEach(item => {
      const quantity = parseFloat(item.querySelector('.quantity-input').value) || 0
      const price = parseFloat(item.querySelector('.price-input').value) || 0
      subtotal += quantity * price
    })
    
    this.subtotalTarget.value = subtotal.toFixed(2)
    
    // Calculate tax if default tax percentage is set
    let tax = parseFloat(this.taxTarget.value) || 0
    if (this.defaultTaxPercentageValue > 0) {
      tax = subtotal * (this.defaultTaxPercentageValue / 100)
      this.taxTarget.value = tax.toFixed(2)
    }
    
    const total = subtotal + tax
    this.totalTarget.value = total.toFixed(2)
  }
}