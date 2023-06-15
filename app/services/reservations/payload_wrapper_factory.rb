module Reservations
  class PayloadWrapperFactory
    class << self
      def for(raw_data)
        parsed_data = JSON.parse(raw_data)

        wrapper_class = matcher_chain.run(parsed_data) || UnidentifiedPayloadWrapper

        wrapper_class.new(
          parsed_data,
          date_parser: date_parser_proc,
        )
      rescue JSON::ParserError => e
        Rails.logger.warn "==> Error parsing JSON: #{e}"

        UnidentifiedPayloadWrapper.new(raw_data)
      end

      private

      def matcher_chain
        airbnb_payload_matcher.chain(
          bookingdotcom_payload_matcher
        )
      end

      def airbnb_payload_matcher
        Reservations::PayloadMatcher.new(
          threshold: 75,
          wrapper: Airbnb::Reservations::PayloadWrapper,
          payload_keys: %w(
            adults
            children
            currency
            end_date
            guest_email
            guest_first_name
            guest_last_name
            guest_phone
            guests
            infants
            nights
            payout_price
            reservation_code
            security_price
            start_date
            status
            total_price
          ),
        )        
      end

      def bookingdotcom_payload_matcher
        Reservations::PayloadMatcher.new(
          threshold: 75,
          wrapper: Bookingdotcom::Reservations::PayloadWrapper,
          payload_keys: %w(
            reservation_code
            reservation_end_date
            reservation_expected_payout_amount
            reservation_guest_details_localized_description
            reservation_guest_details_number_of_adults
            reservation_guest_details_number_of_children
            reservation_guest_details_number_of_infants
            reservation_guest_email
            reservation_guest_first_name
            reservation_guest_last_name
            reservation_guest_phone_numbers
            reservation_host_currency
            reservation_listing_security_price_accurate
            reservation_nights
            reservation_number_of_guests
            reservation_start_date
            reservation_status_type
            reservation_total_paid_amount_accurate
          ),
        )
      end

      def date_parser_proc
        Proc.new { |date|
          begin
            Date.parse(date)
          rescue Date::Error => e
            Rails.logger.warn "==> Error parsing date: #{e}"

            nil
          end
        }
      end
    end
  end
end
