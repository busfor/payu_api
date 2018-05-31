module PayuAPI
  class TrustedMerchantAuthRequest < AuthRequest

    option :email
    option :ext_customer_id

    private

    def body
      "grant_type=trusted_merchant&client_id=#{pos_id}&client_secret=#{key}&email=#{email}&ext_customer_id=#{ext_customer_id}"
    end
  end
end
