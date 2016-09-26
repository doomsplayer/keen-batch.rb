module Keen::Batch::Types
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
    def self.from_str(s)
      case s
      when "minutely" then
        Minutely
      when "hourly" then
        Hourly
      when "daily" then
        Daily
      when "monthly" then
        Monthly
      when "yearly" then
        Yearly
      end
    end

    class IntervalType
      def self.id
        0
      end
    end

    class Minutely < IntervalType
      def self.id
        0
      end
      def self.to_sym
        :minutely
      end
    end

    class Hourly < IntervalType
      def self.id
        1
      end
      def self.to_sym
        :hourly
      end
    end

    class Daily < IntervalType
      def self.id
        2
      end
      def self.to_sym
        :daily
      end
    end
    class Weekly < IntervalType
      def self.id
        3
      end
      def self.to_sym
        :weekly
      end
    end
    class Monthly < IntervalType
      def self.id
        4
      end
      def self.to_sym
        :monthly
      end
    end
    class Yearly < IntervalType
      def self.id
        5
      end
      def self.to_sym
        :yearly
      end
    end
  end

  module Filter
    def self.from_str(s, l, r)
      f = case s
          when 'eq' then
            Filter::Eq
          when 'lt' then
            Filter::Lt
          when 'gt' then
            Filter::Gt
          when 'in' then
            Filter::In    # TODO: add more operators
          when 'ne' then
            Filter::Ne
          end
      f.new(l,r)
    end

    class FilterType
      def initialize(l,r)
        @l = l.to_s
        @r = r.to_s
      end
      def lhs
        @l
      end
      def rhs
        @r
      end
      def id
        0
      end
      def ==(rhs)
        self.class == rhs.class && @l == rhs.lhs && @r == rhs.rhs
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
    class Ne < FilterType
      def id
        6
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
      def ==(rhs)
        self.class == rhs.class && self.target == rhs.target
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
