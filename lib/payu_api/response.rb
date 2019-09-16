module PayuAPI
  class Response
    extend Dry::Initializer::Mixin

    option :http_response

    SUCCESS_HTTP_STATUSES = [200].freeze
    SUCCESS_STATUSES = ['SUCCESS'].freeze

    def success?
      http_success? && status_success?
    end

    def status_code
      status[:statusCode]
    end

    def error?
      !success?
    end

    def error_code
      return unless error?
      body[:error] || status_code
    end

    def error_message
      return unless error?
      body[:error_description] || status_description
    end

    private

    def http_success?
      self.class::SUCCESS_HTTP_STATUSES.include?(http_status)
    end

    def http_status
      @http_status ||= http_response.status
    end

    def status_success?
      self.class::SUCCESS_STATUSES.include?(status_code)
    end

    def status_description
      status[:statusDesc]
    end

    def status
      body[:status] || {}
    end

    def body
      return unless raw_body
      @body ||=
        begin
          JSON.parse(raw_body, symbolize_names: true)
        rescue => e
          raise InvalidResponseError, e.message
        end
    end

    def raw_body
      @raw_body ||= http_response.body
    end
  end
end
