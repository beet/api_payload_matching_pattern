module Reservations
  class PayloadMatcher
    class HashSignatureGenerator
      class << self
        def run(hash)
          nested_hash_keys(hash).flatten.sort
        end

        private

        def nested_hash_keys(hash, parent = nil)
          hash.to_a.sort.map do |key, value|
            prefixed_key = [parent, key].compact.join('_')

            value.is_a?(Hash) ? [prefixed_key, nested_hash_keys(value, prefixed_key)] : prefixed_key
          end
        end
      end
    end

    attr_reader :next_action, :payload, :payload_wrapper, :payload_keys, :threshold

    def initialize(wrapper:, payload_keys:, threshold:)
      @payload_wrapper = wrapper
      @payload_keys = payload_keys
      @threshold = threshold
    end

    def chain(action)
      @next_action = action

      self
    end

    def run(payload)
      @payload = payload

      score >= threshold ? payload_wrapper : next_action.try(:run, payload)
    end

    private

    def score
      matching_keys_count.to_f / payload_keys.size * 100
    end

    def matching_keys_count
      hash_keys = HashSignatureGenerator.run(payload)

      payload_keys.map do |key|
        hash_keys.include?(key)
      end.select { _1 == true}.count
    end
  end
end
