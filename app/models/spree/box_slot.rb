module Spree
  class BoxSlot < Spree::Base
    has_many :boxes

    validates :label, presence: true

    before_save :ensure_default
    after_save :ensure_single_default


    def get_dimensional_boxes(weight_quantities)
      Spree::BoxSlot::Packer.new(self, weight_quantities).boxes
    end

    private

    def ensure_default
      default = Spree::BoxSlot.where(default: true).first
      self.default = true unless default.present?
    end

    def ensure_single_default
      if self.default
        Spree::BoxSlot.where(default: true).where.not(id: self.id).each do |box_slot|
          box_slot.update_columns(default: false)
        end
      end
    end
  end
end