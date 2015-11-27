module KeenNative
  module Result
    class ResultType
      def self.id
        0
      end
    end
    
    class POD < ResultType
      def self.id
        0
      end
    end
    
    class Items < ResultType
      def self.id
        1
      end
    end
    
    class DaysPOD < ResultType
      def self.id
        2
      end
    end
    
    class DaysItems < ResultType
      def self.id
        3
      end
    end
  end
  module Interval
    class IntervalType
      def self.id
        0
      end
    end
    
    class Minutely < IntervalType
      def self.id
        0
      end
    end
    
    class Hourly < IntervalType
      def self.id
        1
      end
    end
    
    class Daily < IntervalType
      def self.id
        2
      end
    end
    class Weekly < IntervalType
      def self.id
        3
      end
    end
    class Monthly < IntervalType
      def self.id
        4
      end
    end
    class Yearly < IntervalType
      def self.id
        5
      end
    end
  end

  module Filter
    class FilterType
      def initialize(l,r)
        @l = l.to_s
        @r = r
      end
      def l
        @l
      end
      def r
        @r
      end
      def id
        0
      end
    end
    
    class Eq < FilterType
      def id
        0
      end
    end
    
    class Lt < FilterType
      def id
        1
      end
    end
    
    class Gt < FilterType
      def id
        2
      end
    end
    
    class Lte < FilterType
      def id
        3
      end
    end
    
    class Gte < FilterType
      def id
        4
      end
    end
    class In < FilterType
      def id
        5
      end
    end
  end

  module Metrics
    class MetricsType
      def id
        0
      end
      def target
        ""
      end
    end
    
    class Count < MetricsType
      def id
        0
      end
    end

    class CountUnique < MetricsType
      def initialize(target)
        target = target.to_s
        raise TypeError.new "target must be string convertable" if target.class != String
        @target = target
      end
      def id
        1
      end
      def target
        @target
      end
    end
  end
end
