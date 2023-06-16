require "rails_helper"

RSpec.describe ReservationsController, type: :controller do
  describe '#create' do
    shared_examples "valid payload" do
      it 'creates a reservation' do
        expect {
          post :create, body: payload
        }.to change {
          Reservation.count
        }.by(1)
      end

      it 'returns the serialised guest' do
        post :create, body: payload

        expect(response.body).to include("\"guest\":#{Reservation.last.guest.to_json}")
      end

      it 'returns the serialised reservation' do
        post :create, body: payload

        expect(response.body).to include("\"reservation\":#{Reservation.last.to_json}")
      end

      it 'returns HTTP status 200 - OK' do
        post :create, body: payload

        expect(response.status).to eq(200)
      end
    end

    shared_examples "invalid payload" do
      it 'does not create a reservation' do
        expect {
          post :create, body: payload
        }.to change {
          Reservation.count
        }.by(0)
      end

      it 'returns the serialised guest with null attributes' do
        post :create, body: payload

        expect(response.body).to include("\"guest\":#{Guest.new.to_json}")
      end

      it 'returns the serialised reservation with null attributes' do
        post :create, body: payload

        expect(response.body).to include("\"reservation\":#{Reservation.new.to_json}")
      end

      it 'returns an error message' do
        post :create, body: payload
        
        expect(JSON.parse(response.body)["errors"]).to eq("Guest is invalid, Code can't be blank, Start date can't be blank, End date can't be blank, Nights can't be blank, Guest is invalid, Code can't be blank, Start date can't be blank, End date can't be blank, and Nights can't be blank")
      end

      it 'returns HTTP status 400 - Bad request' do
        post :create, body: payload

        expect(response.status).to eq(400)
      end
    end

    context 'with a valid AirBnB payload' do
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

      it_behaves_like "valid payload"
    end

    context 'with an invalid AirBnB payload' do
      let(:payload) {
        # Removed the code and guest details
        <<~JSON
          {
            "start_date": "2021-04-14",
            "end_date": "2021-04-18",
            "nights": 4,
            "guests": 7,
            "adults": 2,
            "children": 3,
            "infants": 4,
            "status": "accepted",
            "currency": "AUD",
            "payout_price": "4200.00",
            "security_price": "500",
            "total_price": "4700.00"
          }
        JSON
      }

      it_behaves_like "invalid payload"
    end

    context 'with a valid Booking.com payload' do
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

      it_behaves_like "valid payload"
    end

    context 'with an invalid Booking.com payload' do
      let(:payload) {
        # Removed code and guest details
        <<~JSON
          {
            "reservation": {
              "start_date": "2021-03-12",
              "end_date": "2021-03-16",
              "expected_payout_amount": "3800.00",
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

      it_behaves_like "invalid payload"
    end
  end
end
