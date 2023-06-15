require "spec_helper"

RSpec.describe Reservations::UnidentifiedPayloadWrapper do
  subject(:subject) { described_class.new(payload) }

  shared_examples "null object" do
    describe '#code' do
      it 'is nil' do
        expect(subject.code).to eq(nil)
      end
    end

    describe '#start_date' do
      it 'is nil' do
        expect(subject.start_date).to eq(nil)
      end
    end

    describe '#end_date' do
      it 'is nil' do
        expect(subject.end_date).to eq(nil)
      end
    end

    describe '#nights' do
      it 'is nil' do
        expect(subject.nights).to eq(nil)
      end
    end

    describe '#guests' do
      it 'is nil' do
        expect(subject.guests).to eq(nil)
      end
    end

    describe '#adults' do
      it 'is nil' do
        expect(subject.adults).to eq(nil)
      end
    end

    describe '#children' do
      it 'is nil' do
        expect(subject.children).to eq(nil)
      end
    end

    describe '#infants' do
      it 'is nil' do
        expect(subject.infants).to eq(nil)
      end
    end

    describe '#booking_status' do
      it 'is nil' do
        expect(subject.booking_status).to eq(nil)
      end
    end

    describe '#currency' do
      it 'is nil' do
        expect(subject.currency).to eq(nil)
      end
    end

    describe '#total_price' do
      it 'is nil' do
        expect(subject.total_price).to eq(nil)
      end
    end

    describe '#guest_first_name' do
      it 'is nil' do
        expect(subject.guest_first_name).to eq(nil)
      end
    end

    describe '#guest_last_name' do
      it 'is nil' do
        expect(subject.guest_last_name).to eq(nil)
      end
    end

    describe '#guest_email' do
      it 'is nil' do
        expect(subject.guest_email).to eq(nil)
      end
    end

    describe '#guest_phone_numbers' do
      it 'is nil' do
        expect(subject.guest_phone_numbers).to eq([])
      end
    end
  end

  context "with a JSON payload that is not a recognised reservation" do
    let(:payload) { '{"foo": "bar"}' }

    it_behaves_like "null object"
  end

  context 'with a JSON payload that is a recognised reservation format' do
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

    it_behaves_like "null object"
  end

  context "with a payload that is not valid JSON" do
    let(:payload) { "Internal server error 500" }

    it_behaves_like "null object"
  end
end
