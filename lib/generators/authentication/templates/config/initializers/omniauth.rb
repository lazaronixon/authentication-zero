Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production? # You should replace it with your provider
end
