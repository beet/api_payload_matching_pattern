require "spec_helper"

RSpec.describe Reservations::PayloadWrapperFactory do
  describe "for" do
    subject(:subject) { described_class.for(payload) }

    context "an AirBnB payload" do
      let(:payload) {
        <<~JSON
          {
            "reservation_code": "YYY12345678",
            "start_date": "2021-04-14",
            "end_date": "2021-04-18",
            "nights": 4,
            "guests": 7,
            "adults": 2,
            "children": 3,
            "infants": 4,
            "status": "accepted",
            "guest": {
              "first_name": "Wayne",
              "last_name": "Woodbridge",
              "phone": "639123456789",
              "email": "wayne_woodbridge@bnb.com"
            },
            "currency": "AUD",
            "payout_price": "4200.00",
            "security_price": "500",
            "total_price": "4700.00"
          }
        JSON
      }

      it 'is a Airbnb::Reservations::PayloadWrapper' do
        expect(subject).to be_a(Airbnb::Reservations::PayloadWrapper)
      end

      context 'that is in a different order' do
        let(:payload) {
          <<~JSON
            {
              "reservation_code": "YYY12345678",
              "end_date": "2021-04-18",
              "nights": 4,
              "guests": 7,
              "infants": 4,
              "start_date": "2021-04-14",
              "adults": 2,
              "children": 3,
              "status": "accepted",
              "guest": {
                "first_name": "Wayne",
                "phone": "639123456789",
                "email": "wayne_woodbridge@bnb.com",
                "last_name": "Woodbridge"
              },
              "currency": "AUD",
              "total_price": "4700.00",
              "payout_price": "4200.00",
              "security_price": "500"
            }
          JSON
        }

        it 'is a Airbnb::Reservations::PayloadWrapper' do
          expect(subject).to be_a(Airbnb::Reservations::PayloadWrapper)
        end
      end

      context 'that is missing an attribute' do
        let(:payload) {
          <<~JSON
            {
              "reservation_code": "YYY12345678",
              "end_date": "2021-04-18",
              "nights": 4,
              "guests": 7,
              "start_date": "2021-04-14",
              "adults": 2,
              "children": 3,
              "status": "accepted",
              "guest": {
                "first_name": "Wayne",
                "phone": "639123456789",
                "email": "wayne_woodbridge@bnb.com",
                "last_name": "Woodbridge"
              },
              "currency": "AUD",
              "total_price": "4700.00",
              "payout_price": "4200.00",
              "security_price": "500"
            }
          JSON
        }

        it 'is a Airbnb::Reservations::PayloadWrapper' do
          expect(subject).to be_a(Airbnb::Reservations::PayloadWrapper)
        end
      end
    end

    context "a Booking.com payload" do
      let(:payload) {
        <<~JSON
          {
            "reservation": {
              "code": "XXX12345678",
              "start_date": "2021-03-12",
              "end_date": "2021-03-16",
              "expected_payout_amount": "3800.00",
              "guest_details": {
                "localized_description": "12 guests",
                "number_of_adults": 3,
                "number_of_children": 4,
                "number_of_infants": 5
              },
              "guest_email": "wayne_woodbridge@bnb.com",
              "guest_first_name": "Wayne",
              "guest_last_name": "Woodbridge",
              "guest_phone_numbers": [
                "639123456789",
                "639123456789"
              ],
              "listing_security_price_accurate": "500.00",
              "host_currency": "NZD",
              "nights": 5,
              "number_of_guests": 12,
              "status_type": "initialized",
              "total_paid_amount_accurate": "4300.00"
            }
          }
        JSON
      }

      it 'is a Bookingdotcom::Reservations::PayloadWrapper' do
        expect(subject).to be_a(Bookingdotcom::Reservations::PayloadWrapper)
      end
    end

    context "an unrecognised JSON payload" do
      let(:payload) { '{"foo": "bar"}' }

      it 'is a Reservations::UnidentifiedPayloadWrapper' do
        expect(subject).to be_a(Reservations::UnidentifiedPayloadWrapper)
      end
    end

    context "an invalid payload" do
      let(:payload) { "Internal server error 500" }

      it 'is a Reservations::UnidentifiedPayloadWrapper' do
        expect(subject).to be_a(Reservations::UnidentifiedPayloadWrapper)
      end
    end
  end
end
