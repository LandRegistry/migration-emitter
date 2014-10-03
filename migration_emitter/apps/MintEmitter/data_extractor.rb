class DataExtractor

  #return a hash containing proprietorship information
  def self.get_proprietorship(model)
    proprietorship = {}
    if model['entries'].present?
      model['entries'].detect { |entry|
        if %w(RCAU RPRO).include? entry['role_code']
          proprietorship['template']    = entry['template_text'].present? ? entry['template_text'] : ''
          proprietorship['full_text']   = ''  #TODO - extract full text into model
          proprietorship['fields']      = get_proprietor_fields( entry )
          proprietorship['deeds']       = get_deeds( entry )
          proprietorship['notes']       = get_notes( entry )
        end #of prop entry
      } #end of entry loop
    end  #of entry

    proprietorship
  end

  #return hash of proprietor fields (for new bit of JSON)
  def self.get_proprietor_fields( entry )  #TODO complete code to extract fields
    fields = {}
    json_proprietors = []

    if entry['infills'].present?
      entry['infills'].each do |infill|
        if infill['proprietors'].present?
          infill['proprietors'].each do |proprietor|
            json_proprietor = {}

            json_proprietor['title']                      = proprietor['title'].present? ? proprietor['title'] : ''
            json_proprietor['decoration']                 = proprietor['decoration'].present? ? proprietor['decoration'] : ''
            json_proprietor['first_name']                 = proprietor['name']['forename'].present? ? proprietor['name']['forename'] : ''
            json_proprietor['last_name']                  = proprietor['name']['surname'].present? ? proprietor['name']['surname'] : ''
            json_proprietor['non_private_individual_name']= proprietor['name']['non_private_individual_name'].present? ? proprietor['name']['non_private_individual_name'] : ''

            if json_proprietor['non_private_individual_name'] == ''
              json_proprietor['full_name']                = json_proprietor['first_name'] + ' ' + json_proprietor['last_name']
            else
              json_proprietor['full_name']                = json_proprietor['non_private_individual_name']
            end

            json_proprietor['country_incorporation']       = proprietor['name']['country_incorporation'].present? ? proprietor['name']['country_incorporation'] : ''
            json_proprietor['company_registraion_number']  = proprietor['name']['company_reg_num'].present? ? proprietor['name']['company_reg_num'] : ''
            json_proprietor['name_information']            = proprietor['name']['name_information'].present? ? proprietor['name']['name_information'] : ''
            json_proprietor['occupation']                  = proprietor['name']['name_occupation'].present? ? proprietor['name']['name_occupation'] : ''
            json_proprietor['name_supplimentary']          = proprietor['name']['name_supplimentary'].present? ? proprietor['name']['name_supplimentary'] : ''
            json_proprietor['trading_name']                = proprietor['name']['trading_name'].present? ? proprietor['name']['trading_name'] : ''
            json_proprietor['trust_type']                  = proprietor['name']['trust_format'].present? ? proprietor['name']['trust_format'] : ''
            json_proprietor['decoration']                  = proprietor['name']['decoration'].present? ? proprietor['name']['decoration'] : ''
            json_proprietor['name_category']               = proprietor['name']['name_category'].present? ? proprietor['name']['name_category'] : ''
            json_proprietor['charity_name']                = proprietor['name']['charity_name'].present? ? proprietor['name']['charity_name'] : ''
            json_proprietor['local_authority_area']        = proprietor['name']['local_authority_area'].present? ? proprietor['name']['local_authority_area'] : ''
            json_proprietor['first_name']                  = proprietor['name']['title'].present? ? proprietor['name']['title'] : ''
            json_proprietor['first_name']                  = proprietor['name']['company_location'].present? ? proprietor['name']['company_location'] : ''
            json_proprietor['alias_names']                 = get_alias_names(proprietor['name'])

            json_proprietor['address'] = get_address(entry)
            json_proprietors.push(json_proprietor)
          end
        end
      end
    end

    fields['proprietors'] = json_proprietors
    return fields
  end

  #return hash of address
  def self.get_address(entry)
    address_array = []

    if entry['infills'].present?
      entry['infills'].each do |infill|
        if infill['address'].present?
          address = infill['address']
          json_address = {}

          json_address['full_address']              = address['address_string'] if address['address_string']
          json_address['house_no']                  = address['house_no'] if address['house_no']
          json_address['street_name']               = address['street_name'] if address['street_name']
          json_address['town']                      = address['town'] if address['town']
          json_address['postal_county']             = address['postal_county'] if address['postal_county']
          json_address['region_name']               = address['region_name'] if address['region_name']
          json_address['country']                   = address['country'] if address['country']
          json_address['postcode']                  = address['postcode'] if address['postcode']

          json_address['local_name']                = address['local_name'] if address['local_name']
          json_address['dx_number']                 = address['dx_no'] if address['dx_no']
          json_address['leading_information']       = address['leading_info'] if address['leading_info']
          json_address['sub_building_description']  = address['sub_building_description'] if address['sub_building_description']
          json_address['trailing_information']      = address['trail_info'] if address['trail_info']
          json_address['sub_building_number']       = address['sub_building_no'] if address['sub_building_no']
          json_address['house_alpha']               = address['house_alpha'] if address['house_alpha']
          json_address['plot_no']                   = address['plot_no'] if address['plot_no']
          json_address['secondary_house_alpha']     = address['secondary_house_alpha'] if address['secondary_house_alpha']
          json_address['plot_code']                 = address['plot_code'] if address['plot_code']
          json_address['secondary_house_number']    = address['secondary_house_no'] if address['secondary_house_no']
          json_address['email_address']             = address['email_address'] if address['email_address']
          json_address['address_type']              = address['address_type'] if address['address_type']
          json_address['dx_exchange_name']          = address['exchange_name'] if address['exchange_name']
          json_address['house_description']         = address['house_description'] if address['house_description']

          address_array.push(json_address) if json_address.present?
        end
      end
    end

    address_array
  end  # of get address

  #return array of deeds on entry
  def self.get_deeds( entry )
    deeds_array = []

    if entry['deeds'].present?
      entry['deeds'].each do |deed|
        new_deed = {}
        new_deed['type']              = deed['description'].present? ? deed['description'] : ''
        new_deed['date']              = deed['date'].present? ? deed['date'] : ''
        new_deed['parties']           = '' #TODO - extract deed parties
        new_deed['rentcharge_amount'] = deed['rentcharge_amount'].present? ? deed['rentcharge_amount'] : ''
        new_deed['payment_detail']    = deed['date'].present? ? deed['date'] : ''
        new_deed['lease_term']        = deed['payment_detail'].present? ? deed['payment_detail'] : ''

        deeds_array.push(new_deed) if new_deed.present?
      end # of deed
    end  # of deeds present

    deeds_array
  end

  #return array of notes on entry
  def self.get_notes( entry )
    notes_array = []

    if entry['notes'].present?
      entry['notes'].each do |note|
        new_note = {}
        new_note['text']                = note['text'].present? ? note['text'] : ''
        new_note['documents_referred']  = note['font'].present? ? note['font'] : ''

        notes_array.push(new_note) if new_note.present?
      end # of note
    end  # of notes present

    notes_array
  end

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
              name['alias_names']                 = get_alias_names(props['name'])

              names.push(name) if name.present?
            end #of each prop
          end  #of each infill
          return names
        end #of prop entry
      }
    end #of each entry
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
            address['address'] = get_property_address(entry)
            return address
        end
      }
    end
  end # of get property

  #return hash of address
  def self.get_property_address(entry)
    output = {}
    if entry['infills'][0]['address'].present?
      address = entry['infills'][0]['address']

      output['full_address']              = address['address_string'] if address['address_string']
      output['house_no']                  = address['house_no'] if address['house_no']
      output['street_name']               = address['street_name'] if address['street_name']
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