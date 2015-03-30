#!/usr/bin/env ruby
require 'dotenv'
require 'headless'
require 'libnotify'
require 'logger'
require 'pry'
require 'watir-webdriver'

require_relative './crawlers/hip'
require_relative 'helpers'

Dotenv.load

Helper::LOGGER.info "start"

Headless.ly do
  crawlers = []
  crawlers << HipCrawler.new(ENV['PP_USER'], ENV['PP_PASSWORD'], 'http://pp-hip.pfsl.poznan.pl/', 'PUT')
  crawlers << HipCrawler.new(ENV['UAM_USER'], ENV['UAM_PASSWORD'], 'http://uam-hip.pfsl.poznan.pl/', 'UAM')

  crawlers.each { |crawler| crawler.run }
end

Helper::LOGGER.info 'done'
