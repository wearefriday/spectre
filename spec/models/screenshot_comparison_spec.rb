# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScreenshotComparison do
  same_image = ActionDispatch::Http::UploadedFile.new(tempfile: File.new("#{Rails.root}/spec/support/images/testcard.jpg"), filename: 'testcard.jpg')
  different_image = ActionDispatch::Http::UploadedFile.new(tempfile: File.new("#{Rails.root}/spec/support/images/testcard_large.jpg"), filename: 'testcard_large.jpg')

  let(:same_screenshot_comparison) do
    described_class.new(
      FactoryGirl.create(:test),
      same_image
    )
  end

  let(:different_screenshot_comparison) do
    described_class.new(
      FactoryGirl.create(:test),
      different_image
    )
  end

  it 'should pass a test that is the same as it\'s baseline' do
    expect(same_screenshot_comparison.pass).to eq true
  end

  it 'should fail a test that is different to it\'s baseline' do
    expect(different_screenshot_comparison.pass).to eq false
  end
end
