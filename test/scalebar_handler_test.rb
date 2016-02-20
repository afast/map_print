require 'test_helper'

describe MapPrint::ScalebarHandler do
  let(:scalebar) {
    {
      unit: 'meters', # meters, km, miles, feet
      position: {x: 500, y: 550},
      padding: {top: 5, right: 5, bottom: 5, left: 5},
      bar_height: 10,
      background_color: 'black',
      background_opacity: 0.4,
      size: {width: 200, height: 40}
    }
  }

  let(:scalebar_handler) { MapPrint::ScalebarHandler.new(scalebar, 8) }

  describe '#process' do
    it 'generates the scalebar image' do
      scalebar_handler.process.must_be_kind_of MiniMagick::Image
    end

    it 'generates a scalebar with minimum parameters' do
      MapPrint::ScalebarHandler.new({size: {width: 3, height: 4}}, 1).process.must_be_kind_of MiniMagick::Image
    end
  end

  describe 'Invalid data' do
    it 'throws an error if no data given' do
      proc {
        MapPrint::ScalebarHandler.new({}, -1)
      }.must_raise(MapPrint::NoScalebarData)
    end

    it 'throws an error if no width given' do
      proc {
        MapPrint::ScalebarHandler.new({size: {height: 3}}, 1)
      }.must_raise(MapPrint::InvalidScalebarSize)
    end

    it 'throws an error if no height given' do
      proc {
        MapPrint::ScalebarHandler.new({size: {width: 4}}, 1)
      }.must_raise(MapPrint::InvalidScalebarSize)
    end

    it 'throws an error if no zoom given' do
      proc {
        MapPrint::ScalebarHandler.new({size: {width: 3, height: 4}}, -1)
      }.must_raise(MapPrint::InvalidScalebarZoom)
    end
  end
end
