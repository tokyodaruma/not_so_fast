import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [ 'hoverContent' ]
  static values = { open: Boolean }

  connect() {
    console.log('hey yo');
  }

  hoverAction() {

  }
}
