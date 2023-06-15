module Bookingdotcom
  module Reservations
    class PayloadWrapper
      attr_reader :data, :date_parser

      def initialize(data, date_parser: nil)
        @data = data
        @date_parser = date_parser
      end

      def code
        reservation_data['code']
      end

      def start_date
        date_parser.call(reservation_data['start_date'])
      end

      def end_date
        date_parser.call(reservation_data['end_date'])
      end

      def nights
        reservation_data['nights']
      end

      def guests
        reservation_data['number_of_guests']
      end

      def adults
        reservation_data.dig('guest_details', 'number_of_adults')
      end

      def children
        reservation_data.dig('guest_details', 'number_of_children')
      end

      def infants
        reservation_data.dig('guest_details', 'number_of_infants')
      end

      def booking_status
        reservation_data['status_type']
      end

      def currency
        reservation_data['host_currency']
      end

      def total_price
        reservation_data['total_paid_amount_accurate']
      end

      def guest_first_name
        reservation_data['guest_first_name']
      end

      def guest_last_name
        reservation_data['guest_last_name']
      end

      def guest_email
        reservation_data['guest_email']
      end

      def guest_phone_numbers
        reservation_data['guest_phone_numbers']
      end

      private

      def reservation_data
        data['reservation'] || {}
      end
    end
  end
end
