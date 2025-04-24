class Spree::ActiveShippingConfiguration < Spree::Preferences::Configuration
  preference :ups_login, :string, :default => 'ups_login'
  preference :ups_password, :string, :default => 'ups_password'
  preference :ups_key, :string, :default => 'ups_ke'
  preference :shipper_number, :string, :default => 'shipper_number'

  preference :fedex_login, :string, :default => 'fedex_login'
  preference :fedex_password, :string, :default => 'fedex_password'
  preference :fedex_account, :string, :default => 'fedex_account'
  preference :fedex_key, :string, :default => 'fedex_key'

  preference :units, :string, :default => "imperial"
  preference :unit_multiplier, :decimal, :default => 16 # 16 oz./lb - assumes variant weights are in lbs
  preference :default_weight, :integer, :default => 0 # 16 oz./lb - assumes variant weights are in lbs
  preference :handling_fee, :integer
  preference :max_weight_per_package, :integer, :default => 0 # 0 means no limit

  preference :test_mode, :boolean, :default => false
end
