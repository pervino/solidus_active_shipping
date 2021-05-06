Spree::PermittedAttributes.class_eval do
  class_variable_set(:@@products_attributes, class_variable_get(:@@product_attributes).push(:box_slot_id))
end