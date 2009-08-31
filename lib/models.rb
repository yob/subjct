dbconfig_path = File.join(File.dirname(__FILE__), '..', 'config', 'database.yml')
dbconfig = YAML::load( File.open(dbconfig_path)) 
ActiveRecord::Base.establish_connection(dbconfig)

class BicSubject < ActiveRecord::Base
  has_many :connections
  has_many :bisac_subjects, :through => :connections
end

class BisacSubject < ActiveRecord::Base
  has_many :connections
  has_many :bic_subjects, :through => :connections
end

class Connection < ActiveRecord::Base
  belongs_to :bic_subject
  belongs_to :bisac_subject

  class << self
    def to_csv
      CSV.generate do |csv|
        csv << ["bic2 code","bic2 description","bisac code","bisac description"]

        all(:include => [:bic_subject, :bisac_subject]).each do |conn|
          csv << [conn.bic_subject.code,
                  conn.bic_subject.description,
                  conn.bisac_subject.code,
                  conn.bisac_subject.description]
        end
      end
    end
  end
end
