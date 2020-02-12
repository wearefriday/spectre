# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Test do
  it 'flags if the tests has failed more than five consecutive times' do
    5.times do
      FactoryGirl.create(:test)
    end
    test = FactoryGirl.create(:test)
    expect(test.five_consecutive_failures).to eq true
  end

  it 'should have a default fuzz level of 30%' do
    test = FactoryGirl.create(:test)
    expect(test.fuzz_level).to eq '30%'
  end
end
