module SimpleMessaging
  class MessageQueue

    # Deriving classes need to implement the following methods
    # def enqueue(message)
    # def poll(&block)
    # def pop(&block)

    def self.unregister_queue(name)
      @queues[name] = nil
    end

    def self.driver_name=(driver_name)
      if driver_name != @driver_name
        @driver_class = nil
        @queues = nil
        @driver_name = driver_name.to_s
      end
    end

    def self.instance(name)
      @queues ||= {}
      return @queues[name] if @queues[name]

      @driver_class ||=
        case driver_name
        when 'sqs'
          MessageQueue::SQS
        when 'rabbit'
          MessageQueue::Rabbit
        else
          raise 'Messaging driver "#{driver_name}" not implemented'
        end

      @queues[name] = @driver_class.new(name)
    end

    def self.driver_name
      return @driver_name if @driver_name
      messaging_config_file = Pathname.new(Dir.pwd).join('config', 'messaging.yml').to_s

      if File.exist? messaging_config_file
        messaging_configs = YAML.load(File.open(messaging_config_file).read)
        messaging_configs[environment]['driver']
      else
        raise "Messaging driver isn't set"
      end
    end

    protected

    def environment
      if defined? Rails
        Rails.env
      else
        ENV["RUBY_ENV"] || "development"
      end
    end

    def queue_name(name)
      "#{queue_identifier}-#{name}"
    end

  end
end
