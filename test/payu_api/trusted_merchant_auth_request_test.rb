require 'test_helper'

class PayuAPI::TrustedMerchantAuthRequestTest < Minitest::Test
  def test_it_makes_http_request
    stub_request(:post, "https://secure.payu.com/pl/standard/user/oauth/authorize").
      with(:body => {"client_id"=>"10", "client_secret"=>"absdef", "email"=>"mail@example.com", "ext_customer_id"=>"123", "grant_type"=>"trusted_merchant"},
           :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.15.0'}).
      to_return(status: 200, body: '{"status":"SUCCESS"}')

    request = PayuAPI::TrustedMerchantAuthRequest.new(pos_id: 10, key: 'absdef',email: 'mail@example.com', ext_customer_id: 123)
    response = request.call

    assert_equal 200, response.status
    assert_equal '{"status":"SUCCESS"}', response.body
  end

  def test_it_raise_error_when_timeout
    stub_request(:post, "https://secure.payu.com/pl/standard/user/oauth/authorize").
      with(:body => {"client_id"=>"10", "client_secret"=>"absdef", "email"=>"mail@example.com", "ext_customer_id"=>"123", "grant_type"=>"trusted_merchant"},
           :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.15.0'}).
      to_timeout

    request = PayuAPI::TrustedMerchantAuthRequest.new(pos_id: 10, key: 'absdef',email: 'mail@example.com', ext_customer_id: 123)

    assert_raises(PayuAPI::RequestError) { request.call }
  end

  def test_it_use_sandbox_url
    stub_request(:post, "https://secure.snd.payu.com/pl/standard/user/oauth/authorize").
      with(:body => {"client_id"=>"10", "client_secret"=>"absdef", "email"=>"mail@example.com", "ext_customer_id"=>"123", "grant_type"=>"trusted_merchant"},
           :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.15.0'}).
      to_return(status: 403, body: '{"status":"ERROR"}')

    request = PayuAPI::TrustedMerchantAuthRequest.new(pos_id: 10, key: 'absdef',email: 'mail@example.com', ext_customer_id: 123, sandbox: true)
    response = request.call

    assert_equal 403, response.status
    assert_equal '{"status":"ERROR"}', response.body
  end
end
