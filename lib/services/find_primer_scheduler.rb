require 'sidekiq-scheduler'
require_relative './find_primers.rb'

class FindPrimerScheduler
  include Sidekiq::Worker

  def perform
    vendors = JSON.parse(File.read('./vendors.json'), symbolize_names: true)
    FindPrimers.call(vendors: vendors)
  end
end
