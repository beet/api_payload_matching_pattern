module Airbnb
  module Reservations
    class PayloadWrapper
      attr_reader :data, :date_parser

      def initialize(data, date_parser: nil)
        @data = data
        @date_parser = date_parser
      end

      def code
        data["reservation_code"]
      end

      def start_date
        date_parser.call(data['start_date'])
      end

      def end_date
        date_parser.call(data['end_date'])
      end

      def nights
        data['nights']
      end

      def guests
        data['guests']
      end

      def adults
        data['adults']
      end

      def children
        data['children']
      end

      def infants
        data['infants']
      end

      def booking_status
        data['status']
      end

      def currency
        data['currency']
      end

      def total_price
        data['total_price']
      end

      def guest_first_name
        guest_data['first_name']
      end

      def guest_last_name
        guest_data['last_name']
      end

      def guest_email
        guest_data['email']
      end

      def guest_phone_numbers
        [guest_data['phone']]
      end

      private

      def guest_data
        data['guest'] || {}
      end
    end
  end
end
    