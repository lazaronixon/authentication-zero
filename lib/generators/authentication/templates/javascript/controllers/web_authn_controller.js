import { Controller } from "@hotwired/stimulus"
import { create, get, supported } from "@github/webauthn-json"
import { FetchRequest } from "@rails/request.js"

export default class WebAuthnController extends Controller {
  static targets = [ "error", "button", "supportText" ]
  static classes = [ "loading" ]
  static values = {
    challengeUrl: String,
    verificationUrl: String,
    fallbackUrl: String,
    retryText: { type: String, default: "Retry" },
    notAllowedText: { type: String, default: "That didn't work. Either it was cancelled or took too long. Please try again." },
    invalidStateText: { type: String, default: "We couldn't add that security key. Please confirm you haven't already registered it, then try again." }
  }

  connect() {
    if (!supported()) {
      this.handleUnsupportedBrowser()
    }
  }

  getCredential() {
    this.hideError()
    this.disableForm()
    this.requestChallengeAndVerify(get)
  }

  createCredential() {
    this.hideError()
    this.disableForm()
    this.requestChallengeAndVerify(create)
  }

  // Private

  handleUnsupportedBrowser() {
    this.buttonTarget.parentNode.removeChild(this.buttonTarget)

    if (this.fallbackUrlValue) {
      window.location.replace(this.fallbackUrlValue)
    } else {
      this.supportTextTargets.forEach(target => target.hidden = !target.hidden)
    }
  }

  async requestChallengeAndVerify(fn) {
    try {
      const challengeResponse = await this.requestPublicKeyChallenge()
      const credentialResponse = await fn({ publicKey: challengeResponse })
      this.onCompletion(await this.verify(credentialResponse))
    } catch (error) {
      this.onError(error)
    }
  }

  async requestPublicKeyChallenge() {
    return await this.request("get", this.challengeUrlValue)
  }

  async verify(credentialResponse) {
    return await this.request("post", this.verificationUrlValue, {
      body: JSON.stringify({ credential: credentialResponse }),
      contentType: "application/json",
      responseKind: "json"
    })
  }

  onCompletion(response) {
    window.location.replace(response.location)
  }

  onError(error) {
    if (error.code === 0 && error.name === "NotAllowedError") {
      this.errorTarget.textContent = this.notAllowedTextValue
    } else if (error.code === 11 && error.name === "InvalidStateError") {
      this.errorTarget.textContent = this.invalidStateTextValue
    } else {
      this.errorTarget.textContent = error.message
    }
    this.showError()
  }

  hideError() {
    if (this.hasErrorTarget) this.errorTarget.hidden = true
  }

  showError() {
    if (this.hasErrorTarget) {
      this.errorTarget.hidden = false
      this.buttonTarget.textContent = this.retryTextValue
      this.enableForm()
    }
  }

  enableForm() {
    this.element.classList.remove(this.loadingClass)
    this.buttonTarget.disabled = false
  }

  disableForm() {
    this.element.classList.add(this.loadingClass)
    this.buttonTarget.disabled = true
  }

  async request(method, url, options) {
    const request = new FetchRequest(method, url, { responseKind: "json", ...options })
    const response = await request.perform()
    return response.json
  }
}
