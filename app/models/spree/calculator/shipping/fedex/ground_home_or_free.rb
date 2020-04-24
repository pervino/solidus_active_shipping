require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Fedex
      class GroundHomeOrFree < Spree::Calculator::Shipping::Fedex::Base
        def self.description
          # typically this is whats used to pull the rate AND show the display name in the drop down
          # but with custom named services like this one, we will use this as the label in the drop down
          # and the below service method to pick the associated rate
          "FedEx Ground Home - or - Free"
        end
        def self.service
          I18n.t("fedex.ground_home_delivery")
        end
        def self.check_free(shipment, rate, free_ship_threshold)
          total = shipment.order.item_total.to_i
          binding.pry
          return rate if free_ship_threshold === nil
          if total > free_ship_threshold
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
