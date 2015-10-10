require "keen_native/version"
require 'time'


class KeenNativeBin
  def initialize(url, pid, from_time)
    if url.class != String
      raise "connection must be string"
    end
    if from_time.class != DateTime
      raise "from_time must be datetime"
    end
    @url = url
    @pid = pid.to_i
    @time = from_time.iso8601
  end

  def get_data
    appendix = ""
    if not @redis.nil?
      appendix << " -r '#{@redis}'"
    end

    if @aggregate
      appendix << " -a"
    end

    if @debug
      appendix << " -d"
    end

    cmd = "#{File.dirname(__FILE__)}/keen '#{@url}' '#{@pid}' '#{@time}'"
    cmd << appendix
    result = %x[ #{cmd} ]
    result
  end

  def get_data_async(&block)
    EM.schedule do
      result = get_data
      block.call(result)
    end
  end

  def set_redis(redis_conn)
    if redis_conn.class != String
      raise "connection must be string"
    end
    @redis = redis_conn
    self
  end

  def set_aggregate
    @aggregate = true
  end

  def set_debug
    @debug = true
    self
  end
end
