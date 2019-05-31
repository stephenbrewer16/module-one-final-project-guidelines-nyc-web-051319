#!/usr/bin/env ruby

require_relative '../config/environment'
require 'rest-client'
require 'JSON'
require 'pry'
require 'date'
require 'random_word'


ApplicationController.new.run
