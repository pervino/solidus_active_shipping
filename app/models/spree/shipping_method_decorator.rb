module Spree::ShippingMethodDecorator
  Spree::ShippingMethod.include Spree::ActiveShipping::ShippingMethodConcerns
end

