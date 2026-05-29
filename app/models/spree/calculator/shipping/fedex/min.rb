require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Fedex
      class Min < Spree::Calculator::Shipping::ActiveShipping::Min
        def carrier
          carrier_details = {
            :client_id => Spree::ActiveShipping::Config[:fedex_client_id],
            :client_secret => Spree::ActiveShipping::Config[:fedex_client_secret],
            :account => Spree::ActiveShipping::Config[:fedex_account],
            :test => Spree::ActiveShipping::Config[:test_mode]
          }

          ::ActiveShipping::FedEx.new(carrier_details)
        end
      end
    end
  end
end
