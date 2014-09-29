class DataExtractor
  def self.extract_variables(model)
    @proprietors = get_proprietors( model['entries'].detect { |entry| %w(RCAU RPRO).include? entry['role_code'] } )
    @property = get_property( hash['entries'].detect { |entry| %w(RDES RMRL PPMS).include? entry['role_code'] } )
  end

  def self.get_proprietors(entry)
    names = []
    entry['infills'].each do |infill|
      infill['proprietors'].each do |props|
        name = {}
        name['first_name'] = props['name']['forename'] if props['name']['forename']
        name['last_name'] = props['name']['surname'] if props['name']['surname']
        names.push(name) if name.present?
      end #of each prop
    end  #of each infill
    return names
  end #of get proprietors

  def self.get_property(entry)
    address = {}
    address['address'] = get_address(entry['infills'][0]['address'])
    return address
  end

  def self.get_address(address)
    output = {}
    output['house_no'] = address['house_no'] if address['house_no']
    output['road'] = address['street_name'] if address['street_name']
    output['town'] = address['town'] if address['town']
    output['postcode'] = address['postcode'] if address['postcode']
    output
  end

end