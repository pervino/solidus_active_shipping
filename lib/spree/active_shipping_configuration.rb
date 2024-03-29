class Spree::ActiveShippingConfiguration < Spree::Preferences::Configuration
  preference :ups_login, :string, :default => 'ups_login'
  preference :ups_password, :string, :default => 'ups_password'
  preference :ups_key, :string, :default => 'ups_ke'
  preference :shipper_number, :string, :default => 'shipper_number'

  preference :fedex_login, :string, :default => 'fedex_login'
  preference :fedex_password, :string, :default => 'fedex_password'
  preference :fedex_account, :string, :default => 'fedex_account'
  preference :fedex_key, :string, :default => 'fedex_key'

  preference :usps_login, :string, :default => 'usps_login'

  preference :canada_post_login, :string, :default => 'canada_post_login'

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
