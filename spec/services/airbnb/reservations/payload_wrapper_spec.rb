require "spec_helper"

RSpec.describe Airbnb::Reservations::PayloadWrapper do
  let(:payload) {
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
    }.with_indifferent_access
  }
  let(:date_parser_proc) {
    Proc.new { |date|
      begin
        Date.parse(date)
      rescue Date::Error => e
        Rails.logger.warn "==> Error parsing date: #{e}"

        nil
      end
    }
  }

  subject(:subject) {
    described_class.new(
      payload,
      date_parser: date_parser_proc
    )
  }

  describe '#code' do
    it "is the 'reservation_code'" do
      expect(subject.code).to eq("YYY12345678")
    end
  end

  describe '#start_date' do
    it 'parses the "start_date" to a Date' do
      expect(subject.start_date).to eq(Date.parse('2021-04-14'))
    end
  end

  describe '#end_date' do
    it 'parses the "end_date" to a Date' do
      expect(subject.end_date).to eq(Date.parse('2021-04-18'))
    end
  end

  describe '#nights' do
    it 'parses "nights" to an Integer' do
      expect(subject.nights).to eq(4)
    end
  end

  describe '#guests' do
    it 'parses "guests" to an Integer' do
      expect(subject.guests).to eq(7)
    end
  end

  describe '#adults' do
    it 'parses "adults" to an integer' do
      expect(subject.adults).to eq(2)
    end
  end

  describe '#children' do
    it 'parses "children" to an Integer' do
      expect(subject.children).to eq(3)
    end
  end

  describe '#infants' do
    it 'parses "infants" to an Integer' do
      expect(subject.infants).to eq(4)
    end
  end

  describe '#booking_status' do
    it 'is the "status"' do
      expect(subject.booking_status).to eq('accepted')
    end
  end

  describe '#currency' do
    it 'is the "currency"' do
      expect(subject.currency).to eq('AUD')
    end
  end

  describe '#total_price' do
    it 'is the "total_price"' do
      expect(subject.total_price).to eq('4700.00')
    end
  end

  describe '#guest_first_name' do
    it "is ['guest']['first_name']" do
      expect(subject.guest_first_name).to eq('Wayne')
    end
  end

  describe '#guest_last_name' do
    it "is ['guest']['last_name']" do
      expect(subject.guest_last_name).to eq('Woodbridge')
    end
  end

  describe '#guest_email' do
    it "is ['guest']['email']" do
      expect(subject.guest_email).to eq('wayne_woodbridge@bnb.com')
    end
  end

  describe '#guest_phone_numbers' do
    it "is ['guest']['phone'] in an Array" do
      expect(subject.guest_phone_numbers).to eq(['639123456789'])
    end
  end
end
