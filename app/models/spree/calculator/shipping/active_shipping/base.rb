# This is a base calculator for shipping calcualations using the ActiveShipping plugin.  It is not intended to be
# instantiated directly.  Create subclass for each specific shipping method you wish to support instead.
#
# Digest::MD5 is used for cache_key generation.
require 'digest/md5'
require_dependency 'spree/calculator'
require_dependency 'spree/shipping_error'

module Spree
  module Calculator::Shipping
    module ActiveShipping
      class Base < ShippingCalculator
        include ActiveShipping

        def self.service_name
          self.description
        end

        class_attribute :additional_rate_hooks
        self.additional_rate_hooks = Set.new

        # Use this method in other gems that wish to register their own custom logic
        # that should be called when calculating shipping _rates
        def self.register_additional_rate_hook(hook)
          self.additional_rate_hooks.add(hook)
        end


        def available?(package)
          # helps the available? method determine
          # if rates are avaiable for this service
          # before calling the carrier for rates
          is_package_shippable?(package)

          !compute(package).nil?
        rescue Spree::ShippingError
          false
        end

        def compute_package(package)
          order = package.order
          stock_location = package.stock_location

          origin = build_location(stock_location)
          destination = build_location(order.ship_address)

          boxes = retrieve_boxes_from_cache(package)

          return nil if boxes.empty?

          rates_result = retrieve_rates_from_cache(boxes, origin, destination)

          return nil if rates_result.kind_of?(Spree::ShippingError)
          return nil if rates_result.empty?

          rate = rates_result[self.class.description]
          return nil unless rate

          rate = rate * self.calculable.preferred_cost_multiplier if self.calculable.preferred_cost_multiplier.present?

          handling_cost = Spree::ActiveShipping::Config[:handling_fee].to_f || 0.0
          box_cost = boxes.sum { |box| box.cost * 100 } || 0
          additional_cost = self.additional_rate_hooks.sum { |hook| order.send hook } || 0

          rate = rate.to_f + handling_cost + box_cost + additional_cost

          rate = final_rate_adjustment(rate)
          rate = 0 if rate < 0

          return rate
        end


        def compute_pseudo(box_slot_data, origin_address, destination_address, contains_alcohol = false)

          origin = ::ActiveShipping::Location.new(:country => origin_address[:country],
                                                  :state => origin_address[:state],
                                                  :city => origin_address[:city],
                                                  :zip => origin_address[:zipcode])

          destination = ::ActiveShipping::Location.new(:country => destination_address[:country],
                                                       :state => destination_address[:state],
                                                       :zip => destination_address[:zipcode],
                                                       :address1 => destination_address[:address1],
                                                       :address2 => destination_address[:address2])

          boxes = convert_pseudo_to_simple_packages(box_slot_data)

          shipment_packages = packages(boxes)

          if shipment_packages.empty?
            rates_result ={}
          else
            rates_result = retrieve_rates(origin, destination, shipment_packages)
          end

          return nil if rates_result.kind_of?(Spree::ShippingError)
          return nil if rates_result.empty?

          rate = rates_result[self.class.description]
          return nil unless rate

          rate = rate * self.calculable.preferred_cost_multiplier if self.calculable.preferred_cost_multiplier.present?
          binding.pry


          handling_cost = Spree::ActiveShipping::Config[:handling_fee].to_f || 0.0
          box_cost = boxes.sum { |box| box.cost * 100 } || 0

          rate = rate.to_f + handling_cost + box_cost
          rate = rate.to_f + 162 if contains_alcohol

          rate = final_rate_adjustment(rate)
          rate = 0 if rate < 0

          return rate
        end


        # Divide by 100 since active_shipping rates
        # are received in cents
        def final_rate_adjustment rate
          (rate/100.0).ceil - 0.01
        end

        def timing(line_items)
          order = line_items.first.order
          # TODO: Figure out where stock_location is supposed to come from.
          origin= ::ActiveShipping::Location.new(:country => stock_location.country.iso,
                                                 :city => stock_location.city,
                                                 :state => (stock_location.state ? stock_location.state.abbr : stock_location.state_name),
                                                 :zip => stock_location.zipcode)
          addr = order.ship_address
          destination = ::ActiveShipping::Location.new(:country => addr.country.iso,
                                                       :state => (addr.state ? addr.state.abbr : addr.state_name),
                                                       :city => addr.city,
                                                       :zip => addr.zipcode)
          timings_result = Rails.cache.fetch(cache_key(package)+"-timings") do
            retrieve_timings(origin, destination, packages(order))
          end
          raise timings_result if timings_result.kind_of?(Spree::ShippingError)
          return nil if timings_result.nil? || !timings_result.is_a?(Hash) || timings_result.empty?
          return timings_result[self.description]

        end

        protected

        # weight limit in ounces or zero (if there is no limit)
        def max_weight_for_country(country)
          0
        end

        private

        # We'll let the service alert us of invalid
        # packages rather than hardcoding into the
        # gem. Test this out for UPS to see what
        # happens above the max weight.
        #
        # check for known limitations inside a package
        # that will limit you from shipping using a service
        def is_package_shippable? package
          return true

          # check for weight limits on service
          # country_weight_error? package
        end

        def country_weight_error? package
          max_weight = max_weight_for_country(package.order.ship_address.country)
          raise Spree::ShippingError.new("#{I18n.t(:shipping_error)}: The maximum per package weight for the selected service from the selected country is #{max_weight} ounces.") unless valid_weight_for_package?(package, max_weight)
        end

        # zero weight check means no check
        # nil check means service isn't available for that country
        def valid_weight_for_package? package, max_weight
          return false if max_weight.nil?
          return true if max_weight.zero?
          package.weight <= max_weight
        end

        def retrieve_rates(origin, destination, shipment_packages)
          begin
            response = carrier.find_rates(origin, destination, shipment_packages)
            # turn this beastly array into a nice little hash
            rates = response.rates.collect do |rate|
              service_name = rate.service_name.encode("UTF-8")
              [CGI.unescapeHTML(service_name), rate.price]
            end
            rate_hash = Hash[*rates.flatten]
            return rate_hash
          rescue ::ActiveShipping::Error => e

            if e.class == ::ActiveShipping::ResponseError && e.response.is_a?(::ActiveShipping::Response)
              params = e.response.params
              if params.has_key?("Response") && params["Response"].has_key?("Error") && params["Response"]["Error"].has_key?("ErrorDescription")
                message = params["Response"]["Error"]["ErrorDescription"]
                # Canada Post specific error message
              elsif params.has_key?("eparcel") && params["eparcel"].has_key?("error") && params["eparcel"]["error"].has_key?("statusMessage")
                message = e.response.params["eparcel"]["error"]["statusMessage"]
              else
                message = e.message
              end
            else
              message = e.message
            end

            error = Spree::ShippingError.new("#{I18n.t(:shipping_error)}: #{message}")
            Rails.cache.write @cache_key, error #write error to cache to prevent constant re-lookups
            raise error
          end

        end


        def retrieve_timings(origin, destination, packages)
          begin
            if carrier.respond_to?(:find_time_in_transit)
              response = carrier.find_time_in_transit(origin, destination, packages)
              return response
            end
          rescue ::ActiveShipping::ResponseError => re
            if re.response.is_a?(::ActiveShipping::Response)
              params = re.response.params
              if params.has_key?("Response") && params["Response"].has_key?("Error") && params["Response"]["Error"].has_key?("ErrorDescription")
                message = params["Response"]["Error"]["ErrorDescription"]
              else
                message = re.message
              end
            else
              message = re.message
            end

            error = Spree::ShippingError.new("#{I18n.t(:shipping_error)}: #{message}")
            Rails.cache.write @cache_key+"-timings", error #write error to cache to prevent constant re-lookups
            raise error
          end
        end


        def convert_package_to_simple_boxes(package)
          packages = []
          default_box_slot_id = Spree::BoxSlot.where(default: true).first.try(:id)

          package.contents.group_by { |content_item| content_item.variant.product.box_slot_id || default_box_slot_id }.each do |box_slot_id, content_items|
            next unless (box_slot = Spree::BoxSlot.find_by(id: box_slot_id))

            weight_quantities = {}

            content_items.each do |content_item|
              weight_quantities[content_item.variant.weight] ||= 0
              weight_quantities[content_item.variant.weight] += content_item.quantity
            end

            packages.concat box_slot.get_dimensional_boxes(weight_quantities)
          end


          packages
        end

        # Generates an array of Package objects based on the quantities and weights of the variants in the line items
        def packages(simple_boxes)
          units = Spree::ActiveShipping::Config[:units].to_sym
          packages = []

          simple_boxes.each do |simple_box|
            packages << ::ActiveShipping::Package.new(simple_box.weight, [simple_box.length, simple_box.width, simple_box.height], :units => :imperial)
          end

          packages
        end

        def convert_pseudo_to_simple_packages(pseudo_data)
          simple_boxes = []

          pseudo_data.each do |box_slot_id, weight_quantities|
            box_slot = Spree::BoxSlot.find_by(id: box_slot_id)
            simple_boxes.concat box_slot.get_dimensional_boxes(weight_quantities)
          end

          simple_boxes
        end

        def boxes_cache_key(package)
          last_box_update = Spree::Box.maximum('updated_at').try(:updated_at)
          last_box_slot_update = Spree::BoxSlot.order('updated_at').try(:updated_at)
          contents_hash = Digest::MD5.hexdigest(package.contents.map { |content_item| content_item.variant.weight.to_s + "_" + content_item.quantity.to_s + content_item.variant.product.box_slot_id.to_s }.join("|"))
          @boxes_cache_key = "#{last_box_update}-#{last_box_slot_update}-#{contents_hash}-#{I18n.locale}".gsub(" ", "")
        end

        def rates_cache_key(boxes, origin, destination)
          boxes_hash = Digest::MD5.hexdigest(boxes.map { |box| "#{box.width}_#{box.height}_#{box.length}_#{box.weight}" }.join("|"))
          @cache_key = "#{boxes_hash}-#{carrier.name}-#{location_cache_key(destination)}-#{I18n.locale}".gsub(" ", "")
        end

        def fetch_best_state_from_address address
          address.state ? address.state.abbr : address.state_name
        end

        def build_location address
          ::ActiveShipping::Location.new(:country => address.country.iso,
                                         :state => fetch_best_state_from_address(address),
                                         :city => address.city,
                                         :zip => address.zipcode,
                                         :address1 => address.address1,
                                         :address2 => address.address2)
        end

        def retrieve_boxes_from_cache package
          Rails.cache.fetch(boxes_cache_key(package)) do
            convert_package_to_simple_boxes(package)
          end
        end

        def retrieve_rates_from_cache boxes, origin, destination
          Rails.cache.fetch(rates_cache_key(boxes, origin, destination)) do
            shipment_packages = packages(boxes)
            if shipment_packages.empty?
              {}
            else
              retrieve_rates(origin, destination, shipment_packages)
            end
          end
        end

        def location_cache_key(location)
          "#{location.country_code}-#{location.state}-#{location.zip}"
        end
      end
    end
  end
end
