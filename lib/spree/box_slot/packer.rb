module Spree
  class BoxSlot
    class Packer

      SimpleBox = Struct.new(:weight, :height, :width, :length, :units, :cost)

      # Weight Quantities is a set of weights mapped
      # to quantity of units at that weight
      #
      # Example of 3 units at 16oz and 1 unit at 19oz
      # { 16 => 3, 19 => 1 }
      def initialize(box_slot, units_by_weight)
        @box_slot = box_slot
        @units_by_weight = units_by_weight.sort_by { |weight, units| weight }.reverse.to_h
        @remaining_units = units_by_weight.values.inject { |sum, quantity| sum + quantity }

        boxes
      end

      def boxes
        return @boxes if @boxes

        available_boxes = descending_boxes
        @boxes = put_into_boxes(available_boxes.shift, available_boxes)
        @boxes
      end

      private

      def put_into_boxes(current_box, available_boxes, packed_boxes = [])
        return packed_boxes if @remaining_units == 0

        next_box_slots = available_boxes[0] ? available_boxes[0].slots : 0

        if @remaining_units > next_box_slots
          units_to_pack = [@remaining_units, current_box.slots].min
          packed_boxes << put_into_box(units_to_pack, current_box)
          put_into_boxes(current_box, available_boxes, packed_boxes)
        else
          put_into_boxes(available_boxes.shift, available_boxes, packed_boxes)
        end
      end

      def put_into_box(units, box)
        @remaining_units -= units
        SimpleBox.new(box.weight + get_next_n_units_weight(units), box.height, box.width, box.length, units, box.cost)
      end

      def get_next_n_units_weight(units)
        remaining_units = units
        total_weight = 0

        if @units_by_weight.any?
          @units_by_weight.each do |weight, quantity|

            break unless remaining_units > 0

            if remaining_units > quantity
              total_weight += quantity * weight
              remaining_units -= quantity
              @units_by_weight.delete(weight)
            else
              total_weight += remaining_units * weight
              @units_by_weight[weight] -= remaining_units
              break
            end
          end
        end

        total_weight
      end

      def descending_boxes
        @descending_boxes ||= @box_slot.boxes.order('slots DESC').to_a
      end
    end
  end
end