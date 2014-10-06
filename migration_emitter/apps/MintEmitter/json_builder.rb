require 'jbuilder'
require_relative '../MintEmitter/data_extractor'
require_relative '../MintEmitter/old_json_extractor'
require_relative '../MintEmitter/schedule_extractor'

class JSONBuilder

  def self.convert_hash(model)

    output = Jbuilder.encode do |json|

      #json.ignore_nil! true

      #Old structure
      json.title_number           model['title_number'] if model['title_number']
      json.proprietors            Old_JSON_Extractor.get_proprietors( model )
      json.property               Old_JSON_Extractor.get_property( model )
        json.tenure               model['class'] if model['class']
        json.class_of_title       model['tenure'] if model['tenure']
      json.payment                Old_JSON_Extractor.get_payment( model )
      json.extent                 model['geometry']['extent'] if model['geometry'] && model['geometry']['extent']

      #New structure
      json.tenure                 model['class'] if model['class']
      json.class_of_title         model['tenure'] if model['tenure']
      json.edition_date           ''
      json.last_application       ''
      json.office                 ''
      json.districts              Array.new
      json.proprietorship         DataExtractor.get_proprietorship( model )
      json.property_description   Hash.new
      json.price_paid             DataExtractor.get_price_paid( model )
      json.provisions             Array.new
      json.easements              Array.new
      json.restrictive_covenants  Array.new
      json.restrictions           Array.new
      json.bankruptcy             DataExtractor.get_bankruptcy( model )
      json.charges                Array.new
      json.lease_details          Hash.new
      json.schedules              ScheduleExtractor.get_schedules( model )
      json.geoff                  Array.new
    end #of encode

    return output
  end

end