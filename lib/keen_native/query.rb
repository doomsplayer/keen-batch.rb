module KeenNative
  class KeenNativeQuery
    def initialize(q)
      raise "[keen_native] new query error" if q.null?
      @query = q
      @abandoned = false
      @groupby = false
      @interval = false
    end
    def group_by(group)
      if @abandoned
        raise "object abandoned"
      end

      group = group.to_s
      raise "[keen_native] add group by error" if KeenIoBooster.group_by(@query, group).zero?
      @groupby = true
    end
    def filter(f)
      if @abandoned
        raise "object abandoned"
      end

      raise TypeError.new "filter must be FilterType" if !(f.class < Filter::FilterType)
      raise "[keen_native] add filter error" if KeenIoBooster.filter(@query, f.id, f.l, f.r).zero?
    end
    def interval(i)
      if @abandoned
        raise "object abandoned"
      end
      raise TypeError.new "interval must be IntervalType" if !(i < Interval::IntervalType)
      raise "[keen_native] set interval error" if KeenIoBooster.interval(@query, i.id).zero?
      @interval = true
    end
    def data()
      if @abandoned
        raise "object abandoned"
      end
      @abandoned = true
      type = if @interval && @groupby
        Result::DaysItems
      elsif @interval && !@groupby
        Result::DaysPOD
      elsif !@interval && @groupby
        Result::Items
      else
        Result::POD
      end
      result = KeenIoBooster.data(@query, type.id)
      raise "[keen_native] get data error" if result.null?
      KeenNativeResult.new(result)
    end
  end
end
