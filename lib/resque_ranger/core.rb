require 'resque'

require 'json'

module ResqueRanger

  def self.queues
    @queues ||= QueueManager.new
  end


  class QueueManager
    include Enumerable

    def keys
      Resque.queues
    end

    def key?(name)
      Resque.queues.include?(name.to_s)
    end

    def [](name)
      if self.key?(name)
        Queue.new(name: name.to_s)
      end
    end


    def each
      return enum_for(:each) unless block_given?

      self.keys.each do |k|
        yield self[k]
      end
    end

    def to_s
      self.map{|q| q.name }.to_s
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


    def raw_listing(index, &block)
      block ||= ->(x){ x }

      if index.is_a? Integer
        redis.lrange(formal_name, index, index).map(&block).first
      elsif index.is_a? Range
        # FIXME: This will not work for "..." ranges
        redis.lrange(formal_name, index.begin, index.end).map(&block)
      else
        raise ArgumentError.new("index must be either an Integer or a Range")
      end
    end

    def [](index)
      raw_listing(index) do |listing|
        QueueEntry.create(listing)
      end
    end


    def to_s
      name
    end

  end


  # Wrapper around a single queue entry
  class QueueEntry

    attr_reader :raw_data, :worker_name, :args

    def initialize(options = {})
      @raw_data    = options.fetch(:raw_data)
      @worker_name = options.fetch(:worker_name)
      @args        = options.fetch(:args)
    end

    def self.create(raw_data)
      parsed_data = JSON.parse(raw_data)
      self.new(
        raw_data:    raw_data,
        worker_name: parsed_data["class"],
        args:        parsed_data["args"]
      )
    end


    def to_s
      "#{worker_name}.perform(...)"
    end

    def inspect
      rendered_args = args.map(&:inspect).join(", ")
      "#{worker_name}.perform(#{rendered_args})"
    end

  end

end

