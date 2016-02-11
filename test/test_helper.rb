require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'map_print'

require 'minitest/mock'
require 'minitest/autorun'
require 'webmock/minitest'

WebMock.disable_net_connect!
