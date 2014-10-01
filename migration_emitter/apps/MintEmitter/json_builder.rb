require 'jbuilder'
require_relative '../MintEmitter/data_extractor'

class JSONBuilder

  def self.convert_hash(model)
    #pp hash
    #puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

    output = Jbuilder.encode do |json|
      json.ignore_nil! true
      json.title_number       model['title_number'] if model['title_number']
      json.proprietors        DataExtractor.get_proprietors( model )
      json.property           DataExtractor.get_property( model )
        json.tenure           model['class'] if model['class']
        json.class_of_title   model['tenure'] if model['tenure']
      json.payment            DataExtractor.get_payment( model )
      json.extent             model['geometry']['extent'] if model['geometry'] && model['geometry']['extent']
    end #of encode

    return output
  end

end