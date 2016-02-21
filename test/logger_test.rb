require 'test_helper'

describe MapPrint::Logger do
  let(:logger) { MiniTest::Mock.new }

  before do
    [:debug, :info, :warn, :error, :fatal].each do |level|
      logger.expect(level, nil, ['test'])
    end
  end

  [:debug, :info, :warn, :error, :fatal].each do |level|
    describe "##{level}" do
      it "logs #{level}" do
        logger.expect(level, nil, ['test'])
        Logger.stub(:new, logger) do
          MapPrint::Logger.send(level, 'test')
        end
      end
    end
  end
end
