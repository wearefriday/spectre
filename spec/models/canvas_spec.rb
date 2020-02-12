# frozen_string_literal: true

RSpec.describe Canvas do
  let(:baseline_screenshot_details) { ImageGeometry.new('spec/support/images/testcard.jpg') }
  let(:test_screenshot_details) { ImageGeometry.new('spec/support/images/testcard_large.jpg') }
  let(:canvas) { described_class.new(baseline_screenshot_details, test_screenshot_details) }

  it 'enlarges the canvas to the wider of the two widths' do
    expect(canvas.width).to eq 500
  end

  it 'enlarges the canvas to the wider of the two widths' do
    expect(canvas.height).to eq 375
  end

  it "flags if it's width or height is different to the test screenshot" do
    expect(canvas.dimensions_differ).to eq true
  end

  describe '#to_h' do
    it 'returns a hash of width and height' do
      expect(canvas.to_h).to eq(width: 500, height: 375)
    end
  end

  context 'screenshots are the same dimensions' do
    let(:test_screenshot_details) { ImageGeometry.new('spec/support/images/testcard.jpg') }

    it 'sets the width and height to match the base screenshot' do
      expect(canvas.width).to eq 400
      expect(canvas.height).to eq 300
    end
  end
end
