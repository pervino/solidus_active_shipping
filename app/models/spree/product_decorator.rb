module Spree
  module ProductDecorator
    extend ActiveSupport::Concern

    prepended do
      has_many :product_packages, dependent: :destroy

      accepts_nested_attributes_for :product_packages, allow_destroy: true, reject_if: ->(pp) { pp[:weight].blank? || Integer(pp[:weight]) < 1 }
    end

    def has_product_packages?
      product_packages.any?
    end

    Spree::Product.prepend self
  end
end
