# frozen_string_literal: true

require 'image_geometry'

RSpec.describe ImageGeometry, '#image' do
  it 'calculates the width of an image' do
    image_geometry = ImageGeometry.new('spec/support/images/testcard.jpg')
    expect(image_geometry.width).to eq 400
  end

  it 'calculates the height of an image' do
    image_geometry = ImageGeometry.new('spec/support/images/testcard.jpg')
    expect(image_geometry.height).to eq 300
  end
end
