require 'open-uri'
require 'net/https'

module Net
  class HTTP
    alias_method :original_use_ssl=, :use_ssl=

    def use_ssl=(flag)
      # path = ( Rails.env == "development") ? "lib/ca-bundle.crt" : "/usr/lib/ssl/certs/ca-certificates.crt"
      # if Rails.env == "production"
        path = 'lib/ca-bundle.pem'
        self.ca_file = Rails.root.join(path).to_s
        self.verify_mode = OpenSSL::SSL::VERIFY_PEER
        self.ssl_version = :TLSv1
        self.original_use_ssl = flag
      # end
    end
  end
end