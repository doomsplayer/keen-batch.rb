module Keen::Batch
  class Query
    def initialize(q)
      @query = FFI.check(q) do |t|
        t.null?
      end
    end

    def group_by(group)
      FFI.check(FFI.group_by(@query, group.to_s)) { |t| t.zero? }
      self
    end

    def filter(f)
      raise TypeError.new "filter must be FilterType" if !(f.class < Filter::FilterType)
      FFI.check(FFI.filter(@query, f.id, f.lhs, f.rhs)) { |t| t.zero? }
      self
    end

    def interval(i)
      raise TypeError.new "interval must be IntervalType" if !(i < Interval::IntervalType)
      FFI.check(FFI.interval(@query, i.id)) { |t| t.zero? }
      self
    end

    def other(key, value)
      FFI.check(FFI.other(@query, key.to_s, value.to_s)) { |t| t.zero? }
      self
    end

    def send_query
      result = FFI.data(@query)
      FFI.check(result) { |t| t.null? }
      Result.new(result)
    end
  end
end