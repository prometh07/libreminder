#!/usr/bin/env ruby
require 'dotenv'
require 'headless'
require 'logger'
require 'pry'
require 'watir-webdriver'

require_relative './crawlers/hip'
require_relative './crawlers/br'
require_relative 'helpers'

Dotenv.load

Helper::LOGGER.info "start"

Headless.ly do
  crawlers = []
  crawlers << [HipCrawler, ENV['PP_USER'], ENV['PP_PASSWORD'], 'http://pp-hip.pfsl.poznan.pl/', 'PUT']
  crawlers << [HipCrawler, ENV['UAM_USER'], ENV['UAM_PASSWORD'], 'http://uam-hip.pfsl.poznan.pl/', 'UAM']
  crawlers << [BRCrawler, ENV['BR_USER'], ENV['BR_PASSWORD'], 'http://br-hip.pfsl.poznan.pl/', 'BR']
  crawlers.each do |opts|
    crawler = opts.shift
    crawler.new(*opts).run
  end
end

Helper::LOGGER.info 'done'
