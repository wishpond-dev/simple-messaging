require 'aws-sdk'

module SimpleMessaging

  class MessageQueue::SQS < MessageQueue

    attr_reader :name

    def initialize(name)
      @sqs = Aws::SQS::Client.new
      @queue_url = @sqs.create_queue(queue_name: queue_name(name.to_s)).queue_url
      @name = name
    end

    def enqueue(message)
      @sqs.send_message(queue_url: @queue_url, message_body: message)
    end

    def pop(&block)
      response = @sqs.receive_message(queue_url: @queue_url)
      yield response.messages.first.body
    end

    def poll(&block)
      poller = Aws::SQS::QueuePoller.new(@queue_url)
      poller.poll do |message|
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
