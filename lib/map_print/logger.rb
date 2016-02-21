require 'singleton'
require 'logger'

module MapPrint
  class Logger
    include Singleton

    attr_accessor :logger

    def initialize
      @logger = ::Logger.new File.new('map_print.log', 'a+')
    end

    def debug(*args)
      @logger.debug *args
    end

    def info(*args)
      @logger.info *args
    end

    def warn(*args)
      @logger.warn *args
    end

    def error(*args)
      @logger.error *args
    end

    def fatal(*args)
      @logger.fatal *args
    end

    def self.debug(*args)
      self.instance.debug *args
    end

    def self.info(*args)
      self.instance.info *args
    end

    def self.warn(*args)
      self.instance.warn *args
    end

    def self.error(*args)
      self.instance.error *args
    end

    def self.fatal(*args)
      self.instance.fatal *args
    end
  end
end
