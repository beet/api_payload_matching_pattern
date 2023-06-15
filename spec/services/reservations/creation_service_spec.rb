require "spec_helper"

RSpec.describe Reservations::CreationService do
  subject(:subject) { described_class.new(payload) }

  describe '#run' do
    let(:reservation) { subject.run }
    let(:guest) { reservation.guest }

    context 'with a new AirBnB guest' do
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

      it 'creates a new Guest record' do
        expect(guest).to be_valid

        expect(guest.first_name).to eq("Wayne")
        expect(guest.last_name).to eq("Woodbridge")
        expect(guest.email).to eq("wayne_woodbridge@bnb.com")
        expect(guest.phone_numbers).to eq(["639123456789"])
      end

      it 'creates a new Reservation record' do
        expect(reservation).to be_valid

        expect(reservation.code).to eq("YYY12345678")
        expect(reservation.start_date).to eq(Date.parse("2021-04-14"))
        expect(reservation.end_date).to eq(Date.parse("2021-04-18"))
        expect(reservation.nights).to eq(4)
        expect(reservation.guests).to eq(7)
        expect(reservation.adults).to eq(2)
        expect(reservation.children).to eq(3)
        expect(reservation.infants).to eq(4)
        expect(reservation.booking_status).to eq("accepted")
        expect(reservation.currency).to eq("AUD")
        expect(reservation.total_price).to eq(4700.0)
      end
    end

    context 'with an existing AirBnB guest'do
      let!(:existing_guest) {
        Guest.create!(
          first_name: "Wayne",
          last_name: "Woodbridge",
          email: "wayne_woodbridge@bnb.com",
          phone_numbers: ["639123456789"]
        )
      }

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
              "first_name": "#{existing_guest.first_name}",
              "last_name": "#{existing_guest.last_name}",
              "phone": "#{existing_guest.phone_numbers.first}",
              "email": "#{existing_guest.email}"
            },
            "currency": "AUD",
            "payout_price": "4200.00",
            "security_price": "500",
            "total_price": "4700.00"
          }
        JSON
      }

      it 'does not create a new guest record' do
        expect(reservation.guest).to eq(existing_guest)
      end

      it 'creates a new reservation' do
        expect(reservation).to be_valid

        expect(reservation.code).to eq("YYY12345678")
        expect(reservation.start_date).to eq(Date.parse("2021-04-14"))
        expect(reservation.end_date).to eq(Date.parse("2021-04-18"))
        expect(reservation.nights).to eq(4)
        expect(reservation.guests).to eq(7)
        expect(reservation.adults).to eq(2)
        expect(reservation.children).to eq(3)
        expect(reservation.infants).to eq(4)
        expect(reservation.booking_status).to eq("accepted")
        expect(reservation.currency).to eq("AUD")
        expect(reservation.total_price).to eq(4700.0)
      end
    end

    context 'with a new Booking.com guest' do
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

      it 'creates a new Guest record' do
        expect(guest).to be_valid

        expect(guest.first_name).to eq("Wayne")
        expect(guest.last_name).to eq("Woodbridge")
        expect(guest.email).to eq("wayne_woodbridge@bnb.com")
        expect(guest.phone_numbers).to eq(
          [
            "639123456789",
            "639123456789"
          ]
        )
      end

      it 'creates a new Reservation record' do
        expect(reservation).to be_valid

        expect(reservation.code).to eq("XXX12345678")
        expect(reservation.start_date).to eq(Date.parse("2021-03-12"))
        expect(reservation.end_date).to eq(Date.parse("2021-03-16"))
        expect(reservation.nights).to eq(5)
        expect(reservation.guests).to eq(12)
        expect(reservation.adults).to eq(3)
        expect(reservation.children).to eq(4)
        expect(reservation.infants).to eq(5)
        expect(reservation.booking_status).to eq("initialized")
        expect(reservation.currency).to eq("NZD")
        expect(reservation.total_price).to eq(4300.0)
      end
    end

    context 'with an existing Booking.com guest' do
      let!(:existing_guest) {
        Guest.create!(
          first_name: "Wayne",
          last_name: "Woodbridge",
          email: "wayne_woodbridge@bnb.com",
          phone_numbers: ["639123456789"]
        )
      }

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
              "guest_email": "#{existing_guest.email}",
              "guest_first_name": "#{existing_guest.first_name}",
              "guest_last_name": "#{existing_guest.last_name}",
              "guest_phone_numbers": #{existing_guest.phone_numbers.to_json},
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

      it 'does not create a new guest record' do
        expect(reservation.guest).to eq(existing_guest)
      end


      it 'creates a new Reservation record' do
        expect(reservation).to be_valid

        expect(reservation.code).to eq("XXX12345678")
        expect(reservation.start_date).to eq(Date.parse("2021-03-12"))
        expect(reservation.end_date).to eq(Date.parse("2021-03-16"))
        expect(reservation.nights).to eq(5)
        expect(reservation.guests).to eq(12)
        expect(reservation.adults).to eq(3)
        expect(reservation.children).to eq(4)
        expect(reservation.infants).to eq(5)
        expect(reservation.booking_status).to eq("initialized")
        expect(reservation.currency).to eq("NZD")
        expect(reservation.total_price).to eq(4300.0)
      end
    end

    context 'with an unrecognised JSON payload' do
      let(:payload) { '{"foo": "bar"}' }

      it 'does not create a guest record' do
        expect(guest).to_not be_valid
      end

      it 'does not create a reservation record' do
        expect(reservation).to_not be_valid
      end
    end

    context "an invalid payload" do
      let(:payload) { "Internal server error 500" }

      it 'does not create a guest record' do
        expect(guest).to_not be_valid
      end

      it 'does not create a reservation record' do
        expect(reservation).to_not be_valid
      end
    end
  end
end