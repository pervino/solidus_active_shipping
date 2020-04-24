require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Fedex
      class GroundHomeOrFree < Spree::Calculator::Shipping::Fedex::Base
        def self.description
          "FedEx Ground Home - or - Free"
        end
        def self.descriptions
          [I18n.t("fedex.ground_home_delivery")]
        end
        def self.check_free(shipment, rate, free_ship_threshold)
          total = shipment.order.total.to_i
          subtract_shipping_cost = total - (rate.to_i / 100)
          binding.pry
          return rate if free_ship_threshold === nil
          if subtract_shipping_cost > free_ship_threshold
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
