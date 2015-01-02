OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '485395818249491', 'a0fc33f23c59ac9ee7cfdc444bd4d122', {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}
end