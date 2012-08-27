Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '466077506746774', 'b27293e389779e80046a05d15151b7c5', {:scope => 'publish_stream,offline_access,email'}
end