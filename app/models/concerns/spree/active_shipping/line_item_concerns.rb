module Spree
  module ActiveShipping::LineItemConcerns
    extend ActiveSupport::Concern

    included do
      has_one :box_slot, through: :product
    end
  end
end