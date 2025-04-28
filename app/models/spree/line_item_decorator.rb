module Spree
  module LineItemDecorator
    extend ActiveSupport::Concern

    included do
      has_many :product_packages, :through => :product
    end
  end
end
