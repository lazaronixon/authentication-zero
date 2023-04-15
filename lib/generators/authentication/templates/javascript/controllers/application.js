import { Application } from "@hotwired/stimulus"
import WebAuthnController from "stimulus-web-authn"

const application = Application.start()
application.register("web-authn", WebAuthnController)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
