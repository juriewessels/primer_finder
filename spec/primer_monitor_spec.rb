require 'spec_helper'
require './find_primers'

RSpec.describe FindPrimers do
  it 'kinda works' do
    expect(FindPrimers.call.length).to eq 13
  end
end