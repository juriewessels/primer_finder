require_relative '../spec/spec_helper'
require_relative '../lib/find_primers'

RSpec.describe FindPrimers do
  it 'kinda works' do
    expect(FindPrimers.call.length).to eq 13
  end
end