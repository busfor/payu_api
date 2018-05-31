# PayU REST API

[![Gem Version](https://badge.fury.io/rb/payu_api.svg)](https://badge.fury.io/rb/payu_api)
[![Build Status](https://travis-ci.org/busfor/payu_api.svg?branch=master)](https://travis-ci.org/busfor/payu_api)

Ruby wrapper for PayU REST API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'payu_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install payu_api

## Usage

Get OAuth token:

```ruby
response = PayuAPI.authorize(pos_id: '300046', key: '098f6b...', sandbox: true)

response.success?
# => true

response.auth_token
# => "c8d4b7..."

response.expires_in
# => 43199
```

Create client:

```ruby
client = PayuAPI::Client.new(pos_id: '300046', auth_token: 'c8d4b7...', sandbox: true)
```

Creating a new order:

```ruby
response = client.create_order(
  continueUrl: 'https://your.eshop.com/orders/5kr-120',
  customerIp: '127.0.0.1',
  description: 'RTV market',
  currencyCode: 'PLN',
  totalAmount: 15000,
  extOrderId: '5kr-120',
  buyer: {
    email: 'john.doe@example.com',
    firstName: 'John',
    lastName: 'Doe',
    language: 'en'
  },
  products: [
    {
      name: 'Wireless Mouse for Laptop',
      unitPrice: 15000,
      quantity: 1
    }
  ]
)

response.success?
# => true

response.order_id
# => "H9LL64F37H160126GUEST000P01"

response.redirect_uri
# => "https://secure.payu.com/pl/standard/co/summary?sessionId=..."
```

With error:

```ruby
response.success?
# => false

response.error?
# => true

response.error_code
# => "UNAUTHORIZED_REQUEST"

response.error_message
# => "No privileges to perform the request"
```

Order capture:

```ruby
response = client.capture(order_id: 'H9LL64F37H160126GUEST000P01')

response.success?
# => true
```

Order cancellation:

```ruby
response = client.cancel(order_id: 'H9LL64F37H160126GUEST000P01')

response.success?
# => true
```

Refund:

```ruby
response = client.refund(
  order_id: 'H9LL64F37H160126GUEST000P01',
  params: {
    description: 'Refund',
    currencyCode: 'PLN',
    amount: 1000
  }
)

response.success?
# => true

response.refund
# {
#   refundId: "H9LL64F37H160126GUEST000P02",
#   amount: 1000,
#   currencyCode: "PLN",
#   description: "Refund",
#   creationDateTime: "2016-08-05T15:42:05.241+02:00",
#   status: "PENDING",
#   statusDateTime: "2016-08-05T15:42:05.241+02:00"
# }
```

Get order info:

```ruby
response = client.get_order(order_id: 'H9LL64F37H160126GUEST000P01')

response.success?
# => true

response.order
# {
#   :orderId=>"H9LL64F37H160126GUEST000P01",
#   :orderCreateDate=>"2016-08-05T15:42:05.241+02:00",
#   :customerIp=>"127.0.0.1",
#   :merchantPosId=>"145227",
#   :description=>"RTV market",
#   :currencyCode=>"PLN",
#   :totalAmount=>"15000",
#   :status=>"NEW",
#   :products=>[
#     {
#       :name=>"Wireless Mouse for Laptop",
#       :unitPrice=>"15000",
#       :quantity=>"1"
#     }
#   ]
# }
```

Verify notification signature:

```ruby
PayuAPI.signature_valid?(
  body: request.raw_post,
  headers: request.headers,
  second_key: '17d24f...'
)
# => true
```

Retrieve payment methods which are enabled for pos:

```ruby
response = client.get_paymethods

response.success?
# => true

response.pay_by_links
#  => [
#       {
#         :value=>"m",
#         :brandImageUrl=>"https://static.payu.com/images/mobile/logos/pbl_m.png",
#         :name=>"mTransfer",
#         :status=>"ENABLED"
#       },
#       {
#         :value=>"m",
#         :brandImageUrl=>"https://static.payu.com/images/mobile/logos/pbl_o.png",
#         :name=>"Płacę z Bankiem Pekao S.A.",
#         :status=>"ENABLED"
#       },
#    ]
```
Similarly you can use `response.pex_tokens` to get `pexTokens` and `response.card_tokens` to get `cardTokens`. In case of no results available, the result will be empty array.

To be able to receive payment methods for specific customer of yours, you need to use [different client (trusted merchant)](http://developers.payu.com/en/payu_express.html#payu_express_retrieve).

Get the token for client:

```ruby
response = PayuAPI.authorize_trusted_merchant(pos_id: '300046',
  key: '098f6b...',
  sandbox: true,
  email: 'your@customer.email',
  ext_customer_id: 123456)

response.success?
# => true

response.auth_token
# => "c8d4b7..."

response.expires_in
# => 43199
```

Get client:

```ruby
client = PayuAPI::TrustedMerchantClient.new(pos_id: '300046', auth_token: response.auth_token, sandbox: true)

```

Retrieve payment methods which are enabled for customer:

```ruby
response = client.get_paymethods

response.success?
# => true

response.pay_by_links
#  => [
#       {
#         :value=>"m",
#         :brandImageUrl=>"https://static.payu.com/images/mobile/logos/pbl_m.png",
#         :name=>"mTransfer",
#         :status=>"ENABLED"
#       },
#       {
#         :value=>"m",
#         :brandImageUrl=>"https://static.payu.com/images/mobile/logos/pbl_o.png",
#         :name=>"Płacę z Bankiem Pekao S.A.",
#         :status=>"ENABLED"
#       },
#    ]
```
Similarly you can use `response.pex_tokens` to get `pexTokens` and `response.card_tokens` to get `cardTokens`. In case of no results available, the result will be empty array.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/busfor/payu_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
