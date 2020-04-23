require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Fedex
      class GroundHomeDelivery < Spree::Calculator::Shipping::Fedex::Base
        def self.description
          binding.pry
          I18n.t("fedex.ground_home_delivery")
        end
      end
    end
  end
end
