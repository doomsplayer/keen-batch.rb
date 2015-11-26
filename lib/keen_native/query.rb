module KeenNative
  class KeenNativeQuery
    def initialize(q)
      raise "[keen_native] new query error" if q.null?
      @query = q
      @abandoned = false
    end
    def group_by(group)
      if @abandoned
        raise "object abandoned"
      end
      
      group = group.to_s
      raise "[keen_native] add group by error" if !KeenIoBooster.group_by(@query, group)
    end
    def filter(f)
      if @abandoned
        raise "object abandoned"
      end
      
      raise TypeError.new "filter must be FilterType" if !(f.class < FilterType)
      raise "[keen_native] add filter error" if !KeenIoBooster.filter(@query, f.id, f.l, f.r)
    end
    def interval(i)
      if @abandoned
        raise "object abandoned"
      end
      raise TypeError.new "interval must be IntervalType" if !(i.class < IntervalType)
      raise "[keen_native] set interval error" if !KeenIoBooster.interval(@query, i.id)
    end
    def data(type)
      if @abandoned
        raise "object abandoned"
      end
      @abandoned = true
      raise TypeError.new "data type must be ResultType" if !(type.class < ResultType)
      result = KeenIoBooster.data(type.id)
      raise "[keen_native] get data error" if result.null?
      
      KeenNativeResult.new(result)
    end
  end
  
end
