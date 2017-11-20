class Spree::ActiveShippingConfiguration < Spree::Preferences::Configuration
  # p = Spree::Preference

  # preference :ups_login, :string, :default => p.find_by(key: 'spree/active_shipping_configuration/ups_login').value
  # preference :ups_password, :string, :default => p.find_by(key: 'spree/active_shipping_configuration/ups_password').value
  # preference :ups_key, :string, :default => p.find_by(key: 'spree/active_shipping_configuration/ups_key').value
  # preference :shipper_number, :string, :default => p.find_by(key: 'spree/active_shipping_configuration/shipper_number').value

  # preference :fedex_login, :string, :default => p.find_by(key: 'spree/active_shipping_configuration/fedex_login').value
  # preference :fedex_password, :string, :default => p.find_by(key: 'spree/active_shipping_configuration/fedex_password').value
  # preference :fedex_account, :string, :default => p.find_by(key: 'spree/active_shipping_configuration/fedex_account').value
  # preference :fedex_key, :string, :default => p.find_by(key: 'spree/active_shipping_configuration/fedex_key').value

  # preference :usps_login, :string, :default => p.find_by(key: 'spree/active_shipping_configuration/usps_login').value

  # preference :canada_post_login, :string, :default => p.find_by(key: 'spree/active_shipping_configuration/canada_post_login').value

  # -----------------------

  preference :ups_login, :string, :default => ENV['UPS_LOGIN']
  preference :ups_password, :string, :default => ENV['UPS_PASSWORD']
  preference :ups_key, :string, :default => ENV['UPS_KEY']
  preference :shipper_number, :string, :default => ENV['SHIPPER_NUMBER']

  preference :fedex_login, :string, :default => ENV['FEDEX_LOGIN']
  preference :fedex_password, :string, :default => ENV['FEDEX_PASSWORD']
  preference :fedex_account, :string, :default => ENV['FEDEX_ACCOUNT']
  preference :fedex_key, :string, :default => ENV['FEDEX_KEY']

  preference :usps_login, :string, :default => ENV['USPS_LOGIN']

  preference :canada_post_login, :string, :default => ENV['CANADA_POST_LOGIN']

  # The default values correspond to the official test credentials
  # Source : https://www.canadapost.ca/cpo/mc/business/productsservices/developers/services/fundamentals.jsf
  preference :canada_post_pws_userid, :string, :default => "6e93d53968881714"
  preference :canada_post_pws_password, :string, :default => "0bfa9fcb9853d1f51ee57a"
  preference :canada_post_pws_customer_number, :string, :default => "2004381"
  preference :canada_post_pws_contract_number, :string, :default => "42708517"

  preference :units, :string, :default => "imperial"
  preference :unit_multiplier, :decimal, :default => 16 # 16 oz./lb - assumes variant weights are in lbs
  preference :default_weight, :integer, :default => 0 # 16 oz./lb - assumes variant weights are in lbs
  preference :handling_fee, :integer
  preference :max_weight_per_package, :integer, :default => 0 # 0 means no limit

  preference :test_mode, :boolean, :default => false
end
