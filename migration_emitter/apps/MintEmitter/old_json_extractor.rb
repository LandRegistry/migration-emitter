require_relative 'common_routines'

class Old_JSON_Extractor
  #return array of private individual proprietors
  def self.get_proprietors(model)
    if model['entries'].present?
      model['entries'].each { |entry|
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
              name['company_registration_number'] = props['name']['company_reg_num'].present? ? props['name']['company_reg_num'] : ''
              name['name_information']            = props['name']['name_information'].present? ? props['name']['name_information'] : ''
              name['occupation']                  = props['name']['name_occupation'].present? ? props['name']['name_occupation'] : ''
              name['name_supplementary']          = props['name']['name_supplimentary'].present? ? props['name']['name_supplimentary'] : ''
              name['trading_name']                = props['name']['trading_name'].present? ? props['name']['trading_name'] : ''
              name['trust_type']                  = props['name']['trust_format'].present? ? props['name']['trust_format'] : ''
              name['decoration']                  = props['name']['decoration'].present? ? props['name']['decoration'] : ''
              name['name_category']               = props['name']['name_category'].present? ? props['name']['name_category'] : ''
              name['charity_name']                = props['name']['charity_name'].present? ? props['name']['charity_name'] : ''
              name['local_authority_area']        = props['name']['local_authority_area'].present? ? props['name']['local_authority_area'] : ''
              name['first_name']                  = props['name']['title'].present? ? props['name']['title'] : ''
              name['first_name']                  = props['name']['company_location'].present? ? props['name']['company_location'] : ''
              name['alias_names']                 = CommonRoutines.get_alias_names(props['name'])

              names.push(name) if name.present?
            end #of each prop
          end  #of each infill
          return names
        end #of prop entry
      }
    end #of each entry
  end # of get proprietors

  #return hash of property details including has of address
  def self.get_property(model)
    if model['entries'].present?
      model['entries'].each { |entry|
        if %w(RDES RMRL PPMS).include? entry['role_code']
          address = {}
          address['address'] = get_property_address(entry)
          return address
        end
      }
    end
  end # of get property

  #return hash of address
  def self.get_property_address(entry)
    output = {}
    if entry['infills'].present? && entry['infills'][0]['address'].present?
      address = entry['infills'][0]['address']

      output['full_address']              = address['address_string'] if address['address_string']
      output['house_number']              = address['house_no'] if address['house_no']
      output['road']                      = address['street_name'] if address['street_name']
      output['town']                      = address['town'] if address['town']
      output['postal_county']             = address['postal_county'] if address['postal_county']
      output['region_name']               = address['region_name'] if address['region_name']
      output['country']                   = address['country'] if address['country']
      output['postcode']                  = address['postcode'] if address['postcode']

      output['local_name']                = address['local_name'] if address['local_name']
      output['dx_number']                 = address['dx_no'] if address['dx_no']
      output['leading_information']       = address['leading_info'] if address['leading_info']
      output['sub_building_description']  = address['sub_building_description'] if address['sub_building_description']
      output['trailing_information']      = address['trail_info'] if address['trail_info']
      output['sub_building_number']       = address['sub_building_no'] if address['sub_building_no']
      output['house_alpha']               = address['house_alpha'] if address['house_alpha']
      output['plot_no']                   = address['plot_no'] if address['plot_no']
      output['secondary_house_alpha']     = address['secondary_house_alpha'] if address['secondary_house_alpha']
      output['plot_code']                 = address['plot_code'] if address['plot_code']
      output['secondary_house_number']    = address['secondary_house_no'] if address['secondary_house_no']
      output['email_address']             = address['email_address'] if address['email_address']
      output['address_type']              = address['address_type'] if address['address_type']
      output['dx_exchange_name']          = address['exchange_name'] if address['exchange_name']
      output['house_description']         = address['house_description'] if address['house_description']
    end

    output
  end  # of get address

  #return hash of payment details including array of titles
  def self.get_payment(model)
    price_info = {}

    if model['entries'].present?
      model['entries'].each { |entry|
        if %w(RPPD).include? entry['role_code']

          titles = []
          entry['infills'].each do |infill|
            price_info['price_paid'] = infill['text'] if infill['type'] == 'PRICE'
            titles.push(infill['text']) if infill['type'] == 'TITLE'
          end  #of each infill
          price_info['titles'] = titles if titles.present?
        end
      }
    end

    price_info
  end

end