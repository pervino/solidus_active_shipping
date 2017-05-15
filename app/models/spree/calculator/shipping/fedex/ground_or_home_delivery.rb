require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Fedex
      class GroundOrHomeDelivery < Spree::Calculator::Shipping::Fedex::Min
        def self.description
          "FedEx Min of Ground or Home Delivery"
        end

        def self.descriptions
          [I18n.t("fedex.ground"), I18n.t("fedex.ground_home_delivery")]
        end
      end
    end
  end
end
