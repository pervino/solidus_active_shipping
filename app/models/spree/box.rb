module Spree
  class Box < Spree::Base
    belongs_to :box_slot

    validates :box_slot, presence: true
    validates :slots, presence: true, numericality: {greater_than: 0}
    validates_presence_of :height, :width, :length, :weight, :cost
  end
end