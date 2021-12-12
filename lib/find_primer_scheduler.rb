require 'sidekiq-scheduler'
require_relative '../lib/find_primers.rb'

class FindPrimerScheduler
  include Sidekiq::Worker

  def perform
    logger = Logger.new(STDOUT)
    logger.info("Finding primers...")

    vendors = JSON.parse(File.read('./vendors.json'), symbolize_names: true)
    FindPrimers.call(vendors: vendors)
  end
end
