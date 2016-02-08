require 'test_helper'

describe MapPrint::Providers::Base do
  describe '#initialize' do
    it 'requires subclasses to implement buildingin a provider' do
      proc { MapPrint::Providers::Base.new(nil, nil, 8) }.must_raise RuntimeError
    end
  end
end
