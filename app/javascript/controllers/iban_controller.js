import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.addEventListener("keydown", (e) => this.handleKeyDown(e));
    // Format IBAN on load if it exists
    if (this.element.value) {
      this.formatIBAN();
    }
  }

  sanitize(event) {
    this.formatIBAN();
  }

  formatIBAN() {
    const input = this.element;
    const cursorPos = input.selectionStart;
    
    // Count non-space characters before cursor
    const beforeCursor = input.value.substring(0, cursorPos).replace(/\s/g, "").length;
    
    // Remove all spaces and convert to uppercase
    const unformatted = input.value
      .replace(/\s+/g, "")
      .toUpperCase();
    
    // Format with spaces every 4 characters
    const formatted = unformatted
      .replace(/([a-z0-9]{4})/gi, "$1 ")
      .trim();
    
    input.value = formatted;
    
    // Calculate new cursor position based on character count before cursor
    let newPos = 0;
    let charCount = 0;
    
    for (let i = 0; i < formatted.length; i++) {
      if (formatted[i] !== " ") {
        charCount++;
        if (charCount > beforeCursor) {
          newPos = i;
          break;
        }
      }
      newPos = i + 1;
    }
    
    input.setSelectionRange(newPos, newPos);
  }

  handleKeyDown(event) {
    const allowedKeys = /^(?:[a-z0-9]|Backspace|Delete|Home|End|ArrowLeft|ArrowRight|Shift|CapsLock|Control|Meta|Tab)$/i;
    
    // Allow Ctrl+A, Ctrl+C, Ctrl+V, Ctrl+Z, Ctrl+Y
    const isCtrlKey = event.ctrlKey || event.metaKey;
    const isAllowedCtrlCombo = /^[acvzy]$/i.test(event.key);
    
    if (!allowedKeys.test(event.key) && !(isCtrlKey && isAllowedCtrlCombo)) {
      event.preventDefault();
    }
  }
}
