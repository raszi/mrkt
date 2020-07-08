module Mrkt
  module Faraday
    class ParamsEncoder
      class << self
        def encode(hash)
          new_hash = hash.transform_values { |v| encode_value(v) }
          ::Faraday::NestedParamsEncoder.encode(new_hash)
        end

        def decode(string)
          ::Faraday::NestedParamsEncoder.decode(string)
        end

        def encode_value(value)
          value.respond_to?(:join) ? value.join(',') : value
        end
      end
    end
  end
end
