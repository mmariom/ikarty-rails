import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Modal controller has connected");
  }

  open() {
    this.element.dispatchEvent(new CustomEvent('modal-open', { bubbles: true }));
  }

  close() {
    console.log("Closing modal");
    this.element.classList.add("hidden");
  }
}
