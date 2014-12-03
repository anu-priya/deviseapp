class Country < ActiveRecord::Base
  attr_accessible :country_code, :country_id, :country_name, :inserted_date, :modified_date
end
