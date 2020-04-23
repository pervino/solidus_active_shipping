require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Fedex
      class GroundHomeOrFree < Spree::Calculator::Shipping::Fedex::Base
        def self.description
          I18n.t("fedex.ground_home_delivery")
        end
        def self.check_free(shipment, rate)
          binding.pry
          total = shipment.order.total.to_i
          subtract_shipping_cost = total - (rate / 100)
          if subtract_shipping_cost > 19.99
            rate = 0
            return rate
          else
            return rate
          end
        end
      end
    end
  end
end
