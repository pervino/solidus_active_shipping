module Spree
  module ActiveShipping::ShippingMethodConcerns
    extend ActiveSupport::Concern

    included do
      preference :delivery_days, :integer
      preference :cost_multiplier, :decimal, default: 1


      def self.business_days_estimate placed_on, days
        holidays = [
            Date.new(2015, 5, 25),
            Date.new(2015, 9, 7),
            Date.new(2015, 11, 26),
            Date.new(2015, 12, 25),
            Date.new(2015, 12, 31),
            Date.new(2016, 1, 1)]

        daysLeft = days
        receiveDay = placed_on

        while (daysLeft > 0)
          receiveDay += 1.day
          daysLeft -= 1 unless receiveDay.saturday? || receiveDay.sunday? || holidays.include?(receiveDay)
        end

        return receiveDay
      end

      prepend(InstanceMethods)
    end


    module InstanceMethods
      def delivery_date_estimate(placed_on)
        return nil unless self.preferred_delivery_days && self.preferred_delivery_days > 0
        return self.class.business_days_estimate placed_on, self.preferred_delivery_days
      end
    end
  end
end