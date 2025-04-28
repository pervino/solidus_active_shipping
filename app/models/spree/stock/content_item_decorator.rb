module Spree
  module Stock
    module ContentItemDecorator
      delegate :has_product_packages?, to: :variant, prefix: true

      Spree::Stock::ContentItem.prepend self
    end
  end
end
