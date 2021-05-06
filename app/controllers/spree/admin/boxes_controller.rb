module Spree
  module Admin
    class BoxesController < ResourceController

      def index
        @boxes = Spree::Box.all.order("box_slot_id ASC, slots ASC")
      end

      private

      def permitted_package_attributes
        [:slots, :length, :width, :height, :weight, :cost]
      end
    end
  end
end