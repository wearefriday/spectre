# frozen_string_literal: true

require 'image_processor'

RSpec.describe ImageProcessor do
  it 'crops the image' do
    result = ImageProcessor.crop('spec/support/images/testcard.jpg', '72x14+163+42', 'tmp/testcard_cropped.jpg')
    expect(result).to be true
  end
end
