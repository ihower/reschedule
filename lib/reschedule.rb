require 'redis'
module Reschedule
  
  class NoRuleError < RuntimeError
  end
  
  def self.setup(redis, expired_seconds = 60*60*24*7) # 7 days
    @@redis = redis
    @@expired_seconds = expired_seconds
  end
  
  def self.redis
    @@redis
  end
  
  def self.expired_seconds
    @@expired_seconds
  end
  
  class Day
    
    def redis
      Reschedule.redis
    end
    
    def expired_seconds
      Reschedule.expired_seconds
    end
    
    def initialize(id, year, month, day)
      @id = "#{id}-#{year}-#{month}-#{day}"
      mark(0, -1, 0) # for exists?
    end
        
    def exists?
      redis.exists(@id)
    end
    
    def get
      return redis.smembers(@id) - ["-1"]
    end
    
    def available?(hour, minute, duration=1)
      raise NoRuleError unless self.exists?
      
      t = timestamp(hour, minute)
      
      (t..(t+duration)).each do |m|
        return false unless redis.sismember @id, m
      end
      
      return true
    end
    
    def mark(hour, minute, duration)
      t = timestamp(hour, minute)
      
      (t..(t+duration)).each do |m|
        redis.sadd @id, m
      end
      
      redis.expire @id, expired_seconds
    end
        
    def clean(hour, minute, duration)
      t = timestamp(hour, minute)
      
      # ignore first and last minute for closed time
      ((t+1)..(t+duration-1)).each do |m|
        redis.srem @id, m
      end
      
      redis.expire @id, expired_seconds
    end
    
    def clean_all
      redis.del @id
    end
    
    private
    
    def timestamp(hour, minute)
      hour*60 + minute
    end
    
  end
  
end
