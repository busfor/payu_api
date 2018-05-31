require 'json'
require 'digest'
require 'faraday'
require 'dry-initializer'

require 'payu_api/version'
require 'payu_api/errors'
require 'payu_api/request'
require 'payu_api/api_request'
require 'payu_api/auth_request'
require 'payu_api/trusted_merchant_auth_request'
require 'payu_api/response'
require 'payu_api/responses/auth_response'
require 'payu_api/responses/get_response'
require 'payu_api/responses/create_response'
require 'payu_api/responses/refund_response'
require 'payu_api/responses/paymethods_response'
require 'payu_api/build_signature'
require 'payu_api/order'
require 'payu_api/paymethods'
require 'payu_api/client'
require 'payu_api/trusted_merchant_client'

module PayuAPI
  def self.authorize(pos_id:, key:, sandbox: false)
    request = AuthRequest.new(pos_id: pos_id, key: key, sandbox: sandbox)
    AuthResponse.new(http_response: request.call)
  end

  def self.authorize_trusted_merchant(pos_id:, key:, sandbox: false, email:, ext_customer_id:)
    request = TrustedMerchantAuthRequest.new(pos_id: pos_id, key: key, sandbox: sandbox, email: email, ext_customer_id: ext_customer_id)
    AuthResponse.new(http_response: request.call)
  end

  def self.signature_valid?(body:, headers:, second_key:)
    signature = BuildSignature.new(body: body, second_key: second_key).call
    headers['OpenPayU-Signature'] == signature
  end
end
