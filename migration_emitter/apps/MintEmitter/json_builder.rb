require 'jbuilder'
require_relative '../MintEmitter/data_extractor'
require_relative '../MintEmitter/schedule_extractor'

class JSONBuilder

  def self.convert_hash(model)

    # begin
      output = Jbuilder.encode do |json|
        #json.ignore_nil! true

        json.title_number           model['title_number'] if model['title_number']
        json.extent                 model['geometry']['extent'] if model['geometry'] && model['geometry']['extent']
        json.tenure                 model['class'] if model['class']
        json.class_of_title         model['tenure'] if model['tenure']
        json.edition_date           model['edition_date'] if model['edition_date']
        json.last_application       model['last_app_timestamp'] if model['last_app_timestamp']
        json.office                 model['office'] if model['office']
        json.districts              model['districts'] if model ['districts']
        json.proprietorship         DataExtractor.get_proprietorship( model )
        json.property_description   DataExtractor.get_property_description( model )

        price_paid = DataExtractor.get_price_paid( model )
        if price_paid.present?
          json.price_paid           price_paid
        end

        json.provisions             DataExtractor.get_provisions( model )
        json.easements              DataExtractor.get_easements( model )
        json.restrictive_covenants  DataExtractor.get_restrictive_covenants( model )
        json.restrictions           DataExtractor.get_restrictions( model )
        json.bankruptcy             DataExtractor.get_bankruptcy( model )
        json.charges                DataExtractor.get_charges( model )
        json.d_schedule             ScheduleExtractor.get_d_schedule( model )

        h_schedule = ScheduleExtractor.get_h_schedule( model )
        if h_schedule.present?
          json.h_schedule           h_schedule
        end
        json.other                  Array.new
      end #of encode

      return output
    # rescue
    #   #code has errored so return an error message
    #   error_hash = {}
    #   error_hash['error'] = 'An error occurred building the json'
    #   return error_hash.to_json
    # end
  end

end