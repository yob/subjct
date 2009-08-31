# coding: utf-8

require 'rubygems'
require 'sinatra'
require 'erb'
require 'activerecord'
require 'yaml'
require 'csv'

require File.join(File.dirname(__FILE__), 'lib', 'models')

module Subjectr
  class Application < Sinatra::Base
    set :logging, true
    set :public, File.join(File.dirname(__FILE__), 'public')
    enable :static
    enable :sessions

    get '/' do
      @connection_count = Connection.count
      @bic_count      = BicSubject.count
      @bic_subjects   = BicSubject.all(:order => "code")
      @bisac_count    = BisacSubject.count
      @bisac_subjects = BisacSubject.all(:order => "code")
      erb :index
    end

    post '/by' do
      session["by"] = params["by"].to_s[0,30]
      redirect "/"
    end

    post '/connections' do
      attribs = {:bic_subject_id   => params[:bic_subject_id],
                 :bisac_subject_id => params[:bisac_subject_id],
                 :by               => session["by"]}
      conn = Connection.new(attribs)
      if conn.save
        session["notice"] = "Connection sucessful. Thanks!"
      else
        session["notice"] = "Connection failed"
      end
      redirect "/"
    end

    get '/connections.csv' do
      content_type "text/csv"
      Connection.to_csv
    end

    get '/bic_subjects.csv' do
      bic_path   = File.join(File.dirname(__FILE__), 'data', 'bic2_subjects.csv')
      send_file bic_path, :content_type => "text/csv"
    end

    get '/bisac_subjects.csv' do
      bisac_path = File.join(File.dirname(__FILE__), 'data', 'bisac_subjects.csv')
      send_file bisac_path, :content_type => "text/csv"
    end
  end
end
