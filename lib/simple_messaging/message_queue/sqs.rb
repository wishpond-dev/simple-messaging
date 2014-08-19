require 'aws-sdk'

module SimpleMessaging

  class MessageQueue::SQS < MessageQueue

    attr_reader :name

    def initialize(name)
      @sqs = AWS::SQS.new
      @queue = @sqs.queues.create(queue_name(name))
      @name = name
    end

    def enqueue(message)
      @queue.send_message(message)
    end

    def pop(&block)
      @queue.receive_message do |message|
        yield message.body
      end
    end

    def poll(&block)
      @queue.poll do |message|
        yield message.body
      end
    end

    def delete
      MessageQueue.unregister_queue(name)
      @queue.delete
    end

    private

    def queue_identifier
      case MessageQueue.environment
      when "development"
        prefix = (ENV["SQS_IDENTIFIER"] || `whoami`).strip
        "#{prefix}-development"
      else
        MessageQueue.environment
      end
    end

  end

end
