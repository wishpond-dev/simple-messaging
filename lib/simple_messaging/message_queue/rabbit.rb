require 'amqp'

module SimpleMessaging

  class MessageQueue::Rabbit < MessageQueue

  attr_reader :channel, :queue, :channel, :name

  def initialize(name)
    @@em_thread  ||= Thread.new { EventMachine.run }
    @@connection ||= AMQP.connect(rabbit_configs)
    @channel       = AMQP::Channel.new(@@connection)
    @exchange      = @channel.default_exchange
    @queue         = @channel.queue(queue_name(name))
    @name          = name
  end

  def enqueue(message)
    @exchange.publish message,
      :routing_key => @queue.name,
      :app_id => app_id
  end

  def poll(&block)
    @queue.subscribe do |metadata, payload|
      yield payload
    end
  end

  def pop(&block)
    @queue.subscribe do |metadata, payload|
      yield payload
      break
    end
  end

  def delete
    MessageQueue.unregister_queue(name)
    @queue.delete
  end

  private

  def queue_identifier
    MessageQueue.environment
  end

  def rabbit_configs
    rabbit_config_file = Pathname.new(Dir.pwd).join('config', 'rabbit.yml').to_s
    if File.exist? rabbit_config_file
      YAML.load(File.open(rabbit_config_file).read)[MessageQueue.environment]
    else
      { host: "127.0.0.1" }
    end
  end

  def app_id
    if defined? Rails
      Rails.application.class.parent.to_s
    else
      "unknown"
    end
  end

  end

end
