require 'test_helper'

describe MapPrint::LegendHandler do
  let(:legend_data) {
    {
      position: {x: 50, y: 50},
      size: {width: 400, height: 100},
      image_size: {width: 16, height: 16},
      textbox_size: {width: 40, height: 16},
      image_textbox_separation: 5,
      orientation: 'horizontal', # horizontal, vertical
      overflow: 'hidden', # expand, hidden, compact
      columns: 5,
      rows: 5,
      elements: [{
        image: 'test/assets/marker.png',
        text: 'marker legend'
      },{
        image: 'test/assets/marker.png',
        text: 'marker legend2'
      },{
        image: 'test/assets/marker.png',
        text: 'marker legend3'
      },{
        image: 'test/assets/marker.png',
        text: 'marker legend4'
      },{
        image: 'test/assets/marker.png',
        text: 'marker legend5'
      },{
        image: 'test/assets/marker.png',
        text: 'marker legend6'
      }]
    }
  }
  let(:legend_handler) { MapPrint::LegendHandler.new(legend_data) }

  describe '#process' do
    it 'generates an image with the legend' do
      legend_handler.process.must_be_instance_of MiniMagick::Image
    end

    describe 'missing data' do
      it 'throws an error when no data given' do
        proc {
          MapPrint::LegendHandler.new({})
        }.must_raise MapPrint::NoLegendData
      end

      it 'throws an error if no width given' do
        proc {
          MapPrint::LegendHandler.new({size: {height: 100}})
        }.must_raise MapPrint::InvalidSize
      end

      it 'throws an error if no height given' do
        proc {
          MapPrint::LegendHandler.new({size: {width: 100}})
        }.must_raise MapPrint::InvalidSize
      end

      it 'throws and error if no columns given' do
        proc {
          MapPrint::LegendHandler.new(size: {width: 400, height: 100}, rows: 5)
        }.must_raise MapPrint::MissingLayoutInformation
      end

      it 'throws and error if no rows given' do
        proc {
          MapPrint::LegendHandler.new(size: {width: 400, height: 100}, columns: 5)
        }.must_raise MapPrint::MissingLayoutInformation
      end
    end
  end
end
