require 'dotenv'
require 'headless'
require 'libnotify'
require 'pry'
require 'watir-webdriver'

require_relative './crawlers/hip'
require_relative 'helpers'

Dotenv.load

Headless.ly do
  crawlers = [
    Crawler.new(ENV['PP_USER'], ENV['PP_PASSWORD']),
  ]

  crawlers.each { |crawler| crawler.run }
end
