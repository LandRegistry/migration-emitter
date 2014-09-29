class DataExtractor

  #return array of private individual proprietors
  def self.get_proprietors(model)
    model['entries'].detect { |entry|
      if %w(RCAU RPRO).include? entry['role_code']
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
      end
    }
  end # of get proprietors

  #return hash of property details including has of address
  def self.get_property(model)
    model['entries'].detect { |entry|
      if %w(RDES RMRL PPMS).include? entry['role_code']
          address = {}
          address['address'] = get_address(entry['infills'][0]['address'])
          return address
      end
    }
  end # of get property

  #return hash of address
  def self.get_address(address)
    output = {}
    output['house_no'] = address['house_no'] if address['house_no']
    output['road'] = address['street_name'] if address['street_name']
    output['town'] = address['town'] if address['town']
    output['postcode'] = address['postcode'] if address['postcode']
    output
  end  # of get address

  #return hash of payment details including array of titles
  def self.get_payment(model)
    model['entries'].detect { |entry|
      if %w(RPPD).include? entry['role_code']
        price_info = {}
        titles = []
        entry['infills'].each do |infill|
          price_info['price_paid'] = infill['text'] if infill['type'] == 'PRICE'
          titles.push(infill['text']) if infill['type'] == 'TITLE'
        end  #of each infill
        price_info['titles'] = titles if titles.present?
        return price_info
      end
    }
  end


end