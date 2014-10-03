require 'jbuilder'
require_relative '../MintEmitter/data_extractor'

class JSONBuilder

  def self.convert_hash(model)

    output = Jbuilder.encode do |json|

      json.ignore_nil! true

      #Old structure
      json.title_number           model['title_number'] if model['title_number']
      json.proprietors            DataExtractor.get_proprietors( model )
      json.property               DataExtractor.get_property( model )
        json.tenure               model['class'] if model['class']
        json.class_of_title       model['tenure'] if model['tenure']
      json.payment                DataExtractor.get_payment( model )
      json.extent                 model['geometry']['extent'] if model['geometry'] && model['geometry']['extent']

      #New structure
      json.proprietorship         DataExtractor.get_proprietorship( model )
      json.property_description   Hash.new
      json.price_paid             Array.new
      json.provisions             Array.new
      json.easements              Array.new
      json.restrictive_covenants  Array.new
      json.restrictions           Array.new
      json.bankruptcy             Array.new
    end #of encode

    return output
  end

end