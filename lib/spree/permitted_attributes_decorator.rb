module Spree
  module PermittedAttributesDecorator
    def self.prepended(base)
      base.class_variable_set(:@@products_attributes, base.class_variable_get(:@@product_attributes).push(:box_slot_id))
    end

    Spree::PermittedAttributes.prepend self
  end
end
