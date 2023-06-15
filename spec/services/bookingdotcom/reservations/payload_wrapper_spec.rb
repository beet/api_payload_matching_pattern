require "spec_helper"

RSpec.describe Bookingdotcom::Reservations::PayloadWrapper do
  let(:payload) {
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
    it "is ['reservation']['code']" do
      expect(subject.code).to eq("XXX12345678")
    end
  end

  describe '#start_date' do
    it "is ['reservation']['start_date'] parsed to a Date" do
      expect(subject.start_date).to eq(Date.parse('2021-03-12'))
    end
  end

  describe '#end_date' do
    it "is ['reservation']['end_date'] parsed to a Date" do
      expect(subject.end_date).to eq(Date.parse('2021-03-16'))
    end
  end

  describe '#nights' do
    it "is ['reservation']['nights'] parsed to an Integer" do
      expect(subject.nights).to eq(5)
    end
  end

  describe '#guests' do
    it "is ['reservation']['number_of_guests'] parsed to an Integer" do
      expect(subject.guests).to eq(12)
    end
  end

  describe '#adults' do
    it "is ['reservation']['number_of_adults'] parsed to an Integer" do
      expect(subject.adults).to eq(3)
    end
  end

  describe '#children' do
    it "is ['reservation']['number_of_children'] parsed to an Integer" do
      expect(subject.children).to eq(4)
    end
  end

  describe '#infants' do
    it "is ['reservation']['number_of_infants'] parsed to an Integer" do
      expect(subject.infants).to eq(5)
    end
  end

  describe '#booking_status' do
    it "is ['reservation']['status_type']" do
      expect(subject.booking_status).to eq('initialized')
    end
  end

  describe '#currency' do
    it "is ['reservation']['host_currency']" do
      expect(subject.currency).to eq('NZD')
    end
  end

  describe '#total_price' do
    it "is ['reservation']['total_paid_amount_accurate']" do
      expect(subject.total_price).to eq('4300.00')
    end
  end

  describe '#guest_first_name' do
    it "is ['reservation']['guest_first_name']" do
      expect(subject.guest_first_name).to eq('Wayne')
    end
  end

  describe '#guest_last_name' do
    it "is ['reservation']['guest_last_name']" do
      expect(subject.guest_last_name).to eq('Woodbridge')
    end
  end

  describe '#guest_email' do
    it "is ['reservation']['guest_email']" do
      expect(subject.guest_email).to eq('wayne_woodbridge@bnb.com')
    end
  end

  describe '#guest_phone_numbers' do
    it "is ['reservation']['guest_phone_numbers'] parsed to an Array" do
      expect(subject.guest_phone_numbers).to eq(
        [
          "639123456789",
          "639123456789"
        ]
      )
    end
  end
end
