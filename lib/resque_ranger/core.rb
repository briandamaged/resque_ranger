require 'resque'

module ResqueRanger

  def self.queues
    Resque.queues.map do |q|
      Queue.new(name: q)
    end
  end


  class Queue

    attr_reader :name, :redis

    def initialize(options = {})
      @name  = options.fetch(:name)
      @redis = options.fetch(:redis, Resque.redis)
    end

    def formal_name
      "queue:#{name}"
    end

    def size
      redis.llen(formal_name)
    end

    def purge
      redis.del(formal_name)
    end


    def to_s
      name
    end

  end

end

