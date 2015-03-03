OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '359674387570345', 'fc8da7e958f4b0e985c60770a98bff09', {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}
end