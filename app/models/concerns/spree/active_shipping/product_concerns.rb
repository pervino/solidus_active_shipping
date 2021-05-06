module Spree
  module ActiveShipping::ProductConcerns
    extend ActiveSupport::Concern

    included do
      belongs_to :box_slot
    end
  end
end