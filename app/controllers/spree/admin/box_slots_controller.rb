module Spree
  module Admin
    class BoxSlotsController < ResourceController

      private

      def permitted_box_slot_attributes
        [:label, :default]
      end
    end
  end
end