require 'jbuilder'
require_relative '../MintEmitter/data_extractor'

class JSONBuilder

  def self.convert_hash(hash)
    pp hash

    output = Jbuilder.encode do |json|
      json.ignore_nil! true
      json.title_number       hash['title_number']
      json.proprietors        get_proprietor( hash['entries'].detect { |entry| %w(RCAU RPRO).include? entry['role_code'] } )
      json.property           get_property( hash['entries'].detect { |entry| %w(RDES RMRL PPMS).include? entry['role_code'] } )
        json.tenure           hash['class']
        json.class_of_title   hash['tenure']
    end #of encode

    return output
  end

end