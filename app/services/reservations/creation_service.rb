module Reservations
  class CreationService
    attr_reader :payload, :reservation

    def initialize(payload)
      @payload = payload
    end

    def run
      find_or_create_guest

      create_reservation

      reservation
    end

    private

    attr_reader :guest

    # TODO: if the same name and email is used with different phone numbers,
    # it will create a new record.
    def find_or_create_guest
      @guest = Guest.find_or_create_by(guest_attributes)
    end

    def create_reservation
      @reservation = guest.reservations.build(reservation_attributes)
      
      reservation.save
    end

    def guest_attributes
      {
        first_name: payload_wrapper.guest_first_name,
        last_name: payload_wrapper.guest_last_name,
        email: payload_wrapper.guest_email,
        phone_numbers: payload_wrapper.guest_phone_numbers
      }
    end

    def reservation_attributes
      {
        code: payload_wrapper.code,
        start_date: payload_wrapper.start_date,
        end_date: payload_wrapper.end_date,
        nights: payload_wrapper.nights,
        guests: payload_wrapper.guests,
        adults: payload_wrapper.adults,
        children: payload_wrapper.children,
        infants: payload_wrapper.infants,
        booking_status: payload_wrapper.booking_status,
        currency: payload_wrapper.currency,
        total_price: payload_wrapper.total_price,
      }
    end

    def payload_wrapper
      @payload_wrapper = PayloadWrapperFactory.for(payload)
    end
  end
end
