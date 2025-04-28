module Spree
  module VariantDecorator
    delegate :has_product_packages?, to: :product

    Spree::Variant.prepend self
  end
end
