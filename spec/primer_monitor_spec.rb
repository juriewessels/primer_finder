require './spec_helper'
require '../primer_monitor'

RSpec.describe PrimerMonitor do
  it 'is true' do
    expect(PrimerMonitor.get_availability.length).to eq 9
  end
end