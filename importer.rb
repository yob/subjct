# coding: utf-8

require 'rubygems'
require 'activerecord'
require 'csv'

require File.join(File.dirname(__FILE__), 'lib', 'models')

bic_path   = File.join(File.dirname(__FILE__), 'data', 'bic2_subjects.csv')
bisac_path = File.join(File.dirname(__FILE__), 'data', 'bisac_subjects.csv')

BicSubject.destroy_all

CSV.foreach(bic_path) do |row|
  code, description = *row
  BicSubject.create!(:code => code,
                     :description => description)
end

BisacSubject.destroy_all

CSV.foreach(bisac_path) do |row|
  code, description = *row
  BisacSubject.create!(:code => code,
                       :description => description)
end
