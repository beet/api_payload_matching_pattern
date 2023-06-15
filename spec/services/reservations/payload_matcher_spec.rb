require "spec_helper"

RSpec.describe Reservations::PayloadMatcher do
  subject(:subject) {
    described_class.new(
      threshold: threshold,
      wrapper: wrapper,
      payload_keys: payload_keys,
    )
  }

  let(:threshold) { 75 }
  let(:wrapper) { instance_double(Reservations::UnidentifiedPayloadWrapper) }
  let(:payload_keys) { %w(code nights first_name last_name) }
  let(:next_action) { instance_double(described_class) }

  describe '#chain idiomatic DSL' do
    it 'assigns the next action in the chain' do
      subject.chain(next_action)

      expect(subject.next_action).to eq(next_action)
    end

    it 'returns itself' do
      expect(subject.chain(next_action)).to eq(subject)
    end
  end

  describe '#run' do
    context 'when the payload matches the injected keys exactly' do
      let(:payload) {
        {
          code: '12345667',
          nights: 2,
          first_name: 'Wayne',
          last_name: 'Woodbridge',
        }.with_indifferent_access
      }

      it 'returns the injected payload wrapper' do
        expect(subject.run(payload)).to eq(wrapper)
      end
    end

    context 'when the payload matches the injected keys within the injected threshold' do
      let(:payload) {
        {
          code: '12345667',
          first_name: 'Wayne',
          nights: 2,
        }.with_indifferent_access
      }

      it 'returns the injected payload wrapper' do
        expect(subject.run(payload)).to eq(wrapper)
      end
    end

    context 'when the payload does not match the injected keys within the injected threshold' do
      let(:payload) { { foo: 'bar' } }

      before do
        subject.chain(next_action)
      end

      it 'runs the next action in the chain' do
        expect(next_action).to receive(:run).with(payload)

        subject.run(payload)
      end
    end
  end

  describe Reservations::PayloadMatcher::HashSignatureGenerator do
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

    it 'generates a flattened sorted array of prefixed hash keys for training on payloads' do
      expect(described_class.run(payload)).to eq(
        %w(
          adults
          children
          currency
          end_date
          guest
          guest_email
          guest_first_name
          guest_last_name
          guest_phone
          guests
          infants
          nights
          payout_price
          reservation_code
          security_price
          start_date
          status
          total_price
         )
      )
    end
  end
end
