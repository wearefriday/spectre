require 'canvas'

RSpec.describe Canvas, :type => :model do
  it 'initially sets it\'s width and height to match the base screenshot' do
    baseline_screenshot_details = ImageGeometry.new('spec/support/images/testcard.jpg')
    test_screenshot_details = ImageGeometry.new('spec/support/images/testcard.jpg')
    canvas = Canvas.new(baseline_screenshot_details, test_screenshot_details)
    expect(canvas.width).to eq 400
    expect(canvas.height).to eq 300
  end

  it 'enlarges the canvas to the wider of the two widths' do
    baseline_screenshot_details = ImageGeometry.new('spec/support/images/testcard.jpg')
    test_screenshot_details = ImageGeometry.new('spec/support/images/testcard_large.jpg')
    canvas = Canvas.new(baseline_screenshot_details, test_screenshot_details)
    expect(canvas.width).to eq 500
  end

  it 'enlarges the canvas to the wider of the two widths' do
    baseline_screenshot_details = ImageGeometry.new('spec/support/images/testcard.jpg')
    test_screenshot_details = ImageGeometry.new('spec/support/images/testcard_large.jpg')
    canvas = Canvas.new(baseline_screenshot_details, test_screenshot_details)
    expect(canvas.height).to eq 375
  end

  it 'flags if it\'s width or height is different to the test screenshot' do
    baseline_screenshot_details = ImageGeometry.new('spec/support/images/testcard.jpg')
    test_screenshot_details = ImageGeometry.new('spec/support/images/testcard_large.jpg')
    canvas = Canvas.new(baseline_screenshot_details, test_screenshot_details)
    expect(canvas.dimensions_differ).to eq true
  end
end
