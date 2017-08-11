module PayuAPI
  class CreateResponse < Response
    SUCCESS_HTTP_STATUSES = [200, 201, 302].freeze
    SUCCESS_STATUSES = [
      'SUCCESS',
      'WARNING_CONTINUE_3DS',
      'WARNING_CONTINUE_CVV'
    ].freeze

    def order_id
      body[:orderId]
    end

    def redirect_uri
      body[:redirectUri]
    end
  end
end
