shared_context 'FedEx setup' do
  before do
    WebMock.allow_net_connect!
    config = Spree::ActiveShippingConfiguration.new
    config.fedex_client_id = 'test_client_id'
    config.fedex_client_secret = 'test_client_secret'
    config.fedex_account = '510087143'
    config.test_mode = true
  end

  after do
    WebMock.disable_net_connect!
  end
end
