import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.textContent = this.element.textContent
      .replace("[at]", "@")
      .replace("[dot]", ".")
      .replaceAll("00000000", " ");
  }
}
