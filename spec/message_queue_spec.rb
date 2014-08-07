require 'spec_helper'

RSpec.describe SimpleMessaging::MessageQueue, 'loads appropriate driver' do

  context 'Using SQS driver' do

    before(:each) do
      SimpleMessaging::MessageQueue.driver_name = "sqs"
      @queue = SimpleMessaging::MessageQueue.instance("test-queue")
    end

    it 'should load' do
      expect(@queue.class.name.to_s).to eq "SimpleMessaging::MessageQueue::SQS"
    end

    it 'should publish messages' do
      @queue.enqueue("Message")
      @queue.pop do |message|
        expect(message).to eq "Message"
        expect(message).not_to eq "Potato"
      end
    end
  end

  context 'Using the RabbitMQ driver' do

    before(:each) do
      SimpleMessaging::MessageQueue.driver_name = "rabbit"
      @queue = SimpleMessaging::MessageQueue.instance("test-queue")
    end

    it 'should load the rabbitmq driver' do
      expect(@queue.class.name.to_s).to eq "SimpleMessaging::MessageQueue::Rabbit"
    end

    it 'should publish and receive messages' do
      @queue.enqueue("Potato")
      @queue.pop do |message|
        expect(message).to eq "Message"
        expect(message).not_to eq "Potato"
      end
    end
  end

end
