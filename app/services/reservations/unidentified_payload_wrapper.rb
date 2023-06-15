module Reservations
  class UnidentifiedPayloadWrapper
    attr_reader :data, :date_parser

    def initialize(data, date_parser: nil)
      @data = data
      @date_parser = date_parser
    end

    def code; end

    def start_date; end

    def end_date; end

    def nights; end

    def guests; end

    def adults; end

    def children; end

    def infants; end

    def booking_status; end

    def currency; end

    def total_price; end

    def guest_first_name; end

    def guest_last_name; end

    def guest_email; end
      
    def guest_phone_numbers
      []
    end
  end
end
