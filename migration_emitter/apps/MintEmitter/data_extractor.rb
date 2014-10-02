class DataExtractor

  #return array of private individual proprietors
  def self.get_proprietors(model)
    if model['entries'].present?
      model['entries'].detect { |entry|
        if %w(RCAU RPRO).include? entry['role_code']
          names = []
          entry['infills'].each do |infill|
            infill['proprietors'].each do |props|
              name = {}
              name['first_name'] = props['name']['forename'].present? ? props['name']['forename'] : ''
              name['last_name'] = props['name']['surname'].present? ? props['name']['surname'] : ''
              name['non_private_individual_name'] = props['name']['non_private_individual_name'].present? ? props['name']['non_private_individual_name'] : ''
              if name['non_private_individual_name'] == ''
                name['full_name'] = name['first_name'] + ' ' + name['last_name']
              else
                name['full_name'] = name['non_private_individual_name']
              end

              name['country_incorporation']       = props['name']['country_incorporation'].present? ? props['name']['country_incorporation'] : ''
              name['company_registraion_number']  = props['name']['company_reg_num'].present? ? props['name']['company_reg_num'] : ''
              name['name_information']            = props['name']['name_information'].present? ? props['name']['name_information'] : ''
              name['occupation']                  = props['name']['name_occupation'].present? ? props['name']['name_occupation'] : ''
              name['name_supplimentary']          = props['name']['name_supplimentary'].present? ? props['name']['name_supplimentary'] : ''
              name['trading_name']                = props['name']['trading_name'].present? ? props['name']['trading_name'] : ''
              name['trust_type']                  = props['name']['trust_format'].present? ? props['name']['trust_format'] : ''
              name['decoration']                  = props['name']['decoration'].present? ? props['name']['decoration'] : ''
              name['name_category']               = props['name']['name_category'].present? ? props['name']['name_category'] : ''
              name['charity_name']                = props['name']['charity_name'].present? ? props['name']['charity_name'] : ''
              name['local_authority_area']        = props['name']['local_authority_area'].present? ? props['name']['local_authority_area'] : ''
              name['first_name']                  = props['name']['title'].present? ? props['name']['title'] : ''
              name['first_name']                  = props['name']['company_location'].present? ? props['name']['company_location'] : ''
              name['alias_names']                  = get_alias_names(props['name'])

              names.push(name) if name.present?
            end #of each prop
          end  #of each infill
          return names
        end
      }
    end
  end # of get proprietors

  #return array of alias names
  def self.get_alias_names(name_hash)
    alias_array = []   #create empty array which will be the minimum returned
    if name_hash['alias_names'].present?   #is anything in alias names?
      name_hash['alias_names'].each do |alias_name|   #if alias names present loop through each one
        proprietor_alias = {}  #we have an alias so create array and populate
        proprietor_alias['forename']    = alias_name['forename'] ? alias_name['forename'] : ''
        proprietor_alias['surname']     = alias_name['surname'] ? alias_name['surname'] : ''
        proprietor_alias['title']       = alias_name['title'] ? alias_name['title'] : ''
        proprietor_alias['decoration']  = alias_name['decoration'] ? alias_name['decoration'] : ''

        alias_array.push(proprietor_alias) if proprietor_alias.present?
      end
    end

    return alias_array   #return array
  end

  #return hash of property details including has of address
  def self.get_property(model)
    if model['entries'].present?
      model['entries'].detect { |entry|
        if %w(RDES RMRL PPMS).include? entry['role_code']
            address = {}
            address['address'] = get_address(entry['infills'][0]['address'])
            return address
        end
      }
    end
  end # of get property

  #return hash of address
  def self.get_address(address)
    output = {}
    output['full_address'] = address['addr_string'] if address['address_string']
    output['house_no'] = address['house_no'] if address['house_no']
    output['street_name'] = address['street_name'] if address['street_name']
    output['town'] = address['town'] if address['town']
    output['postal_county'] = address['postal_county'] if address['postal_county']
    output['region_name'] = address['region_name'] if address['region_name']
    output['country'] = address['country'] if address['country']
    output['postcode'] = address['postcode'] if address['postcode']



    output
  end  # of get address

  #return hash of payment details including array of titles
  def self.get_payment(model)
    if model['entries'].present?
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


end