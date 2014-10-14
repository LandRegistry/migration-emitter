#require_relative 'common_routines'

class DataExtractor

  def self.extract_entry( entry )
    json_entry           = set_up_entry( entry )
    json_entry['fields'] = populate_fields( entry )

    json_entry
  end

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

  #return array of deeds on entry
  def self.get_deeds( entry )
    deeds_array = []

    if entry['deeds'].present?
      entry['deeds'].each do |deed|
        new_deed = {}
        new_deed['type']              = deed['description'].present? ? deed['description'] : ''
        new_deed['date']              = deed['date'].present? ? deed['date'] : ''
        new_deed['parties']           = get_deed_parties( deed )
        new_deed['rentcharge_amount'] = deed['rentcharge_amount'].present? ? deed['rentcharge_amount'] : ''
        new_deed['payment_detail']    = deed['payment_detail'].present? ? deed['payment_detail'] : ''
        new_deed['lease_term']        = deed['lease_term'].present? ? deed['lease_term'] : ''

        deeds_array.push(new_deed) if new_deed.present?
      end # of deed
    end  # of deeds present

    deeds_array
  end

  #return an array of parties
  def self.get_deed_parties( deed )
    parties = []

    if deed['parties'].present?
      deed['parties'].each do |party|
        party_array = []
        if party['names'].present?
          party['names'].each do |name|
            json_name = get_name_details(name)
            party_array.push(json_name) if json_name.present?
          end  #of each party name
        end  #of  party name present
        parties.push(party_array) if party_array.present?
      end  #of each party
    end   #of party present

    parties
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

  def self.set_up_entry( entry )
    new_entry = {}

    new_entry['deeds']            = get_deeds( entry )
    new_entry['notes']            = get_notes( entry )
    new_entry['full_text']        = entry['full_text'].present? ? entry['full_text'] : ''
    new_entry['entry_date']       = entry['entry_date'].present? ? entry['entry_date'] : ''
    new_entry['role_code']        = entry['role_code'].present? ? entry['role_code'] : ''
    new_entry['status']           = entry['status'].present? ? entry['status'] : ''
    new_entry['lang_code']        = entry['language'].present? ? entry['language'] : ''
    new_entry['sub_register']     = entry['sub_register'].present? ? entry['sub_register'] : ''
    new_entry['template']         = entry['template_text'].present? ? entry['template_text'] : ''
    new_entry['template_code']    = entry['draft_entry_code'].present? ? entry['draft_entry_code'] : ''
    new_entry['template_version'] = entry['draft_entry_version'].present? ? entry['draft_entry_version'] : ''

    new_entry
  end

  #return hash of name details
  def self.get_name_details ( name )
    json_name = {}

    json_name['title']                       = name['title'].present? ? name['title'] : ''
    json_name['decoration']                  = name['decoration'].present? ? name['decoration'] : ''
    json_name['first_name']                  = name['forename'].present? ? name['forename'] : ''
    json_name['last_name']                   = name['surname'].present? ? name['surname'] : ''
    json_name['non_private_individual_name'] = name['non_private_individual_name'].present? ? name['non_private_individual_name'] : ''

    if json_name['non_private_individual_name'] == ''
      if json_name['first_name'] .present? #check if only a surname is present
        json_name['full_name'] = json_name['first_name'] + ' ' + json_name['last_name']
      else
        json_name['full_name'] = json_name['last_name']
      end
    else
      json_name['full_name']   = json_name['non_private_individual_name']
    end

    json_name['country_incorporation']       = name['country_incorporation'].present? ? name['country_incorporation'] : ''
    json_name['company_registration_number'] = name['company_reg_num'].present? ? name['company_reg_num'] : ''
    json_name['name_information']            = name['name_information'].present? ? name['name_information'] : ''
    json_name['occupation']                  = name['name_occupation'].present? ? name['name_occupation'] : ''
    json_name['name_supplementary']          = name['name_supplimentary'].present? ? name['name_supplimentary'] : ''
    json_name['trading_name']                = name['trading_name'].present? ? name['trading_name'] : ''
    json_name['trust_type']                  = name['trust_format'].present? ? name['trust_format'] : ''
    json_name['decoration']                  = name['decoration'].present? ? name['decoration'] : ''
    json_name['name_category']               = name['name_category'].present? ? name['name_category'] : ''
    json_name['charity_name']                = name['charity_name'].present? ? name['charity_name'] : ''
    json_name['local_authority_area']        = name['local_authority_area'].present? ? name['local_authority_area'] : ''
    json_name['first_name']                  = name['title'].present? ? name['title'] : ''
    json_name['first_name']                  = name['company_location'].present? ? name['company_location'] : ''
    json_name['alias_names']                = get_alias_names(name)

    json_name
  end

  def self.populate_fields( entry )
    fields = {}
    if entry['infills'].present?
      entry['infills'].each do |infill|
        type = infill['type'].present? ? infill['type'].downcase : 'miscellaneous'

        case type
          when 'charge proprietor'
            if fields['proprietors'].nil?
              fields['proprietors'] = []
            end
            fields['proprietors'].push( get_proprietor_fields( entry ) )
          when 'proprietor'
            if fields['proprietors'].nil?
              fields['proprietors'] = []
            end
            fields['proprietors'] = get_proprietor_fields( entry )
          when 'address'
            fields['addresses'] = populate_address( infill['address'] )
          else
            if fields[type].nil?
              fields[type] = []
            end
            text = infill['text'].present? ? infill['text'] : ''
            fields[type].push( text )
        end
      end
    end

    fields
  end

  #return hash of proprietor fields (for new bit of JSON)
  def self.get_proprietor_fields( entry )
    json_proprietors = []

    if entry['infills'].present?
      entry['infills'].each do |infill|
        if infill['proprietors'].present?
          infill['proprietors'].each do |proprietor|
            json_proprietor = {}
            json_proprietor_name = {}

            json_proprietor_name['title']                       = proprietor['name']['title'].present? ? proprietor['title'] : ''
            json_proprietor_name['decoration']                  = proprietor['name']['decoration'].present? ? proprietor['decoration'] : ''
            json_proprietor_name['first_name']                  = proprietor['name']['forename'].present? ? proprietor['name']['forename'] : ''
            json_proprietor_name['last_name']                   = proprietor['name']['surname'].present? ? proprietor['name']['surname'] : ''
            json_proprietor_name['non_private_individual_name'] = proprietor['name']['non_private_individual_name'].present? ? proprietor['name']['non_private_individual_name'] : ''

            if json_proprietor_name['non_private_individual_name'] == ''
              if json_proprietor_name['first_name'] .present? #check if only a surname is present
                json_proprietor_name['full_name'] = json_proprietor_name['first_name'] + ' ' + json_proprietor_name['last_name']
              else
                json_proprietor_name['full_name'] = json_proprietor_name['last_name']
              end
            else
              json_proprietor_name['full_name']   = json_proprietor_name['non_private_individual_name']
            end

            json_proprietor_name['country_incorporation']       = proprietor['name']['country_incorporation'].present? ? proprietor['name']['country_incorporation'] : ''
            json_proprietor_name['company_registration_number'] = proprietor['name']['company_reg_num'].present? ? proprietor['name']['company_reg_num'] : ''
            json_proprietor_name['name_information']            = proprietor['name']['name_information'].present? ? proprietor['name']['name_information'] : ''
            json_proprietor_name['occupation']                  = proprietor['name']['name_occupation'].present? ? proprietor['name']['name_occupation'] : ''
            json_proprietor_name['name_supplementary']          = proprietor['name']['name_supplimentary'].present? ? proprietor['name']['name_supplimentary'] : ''
            json_proprietor_name['trading_name']                = proprietor['name']['trading_name'].present? ? proprietor['name']['trading_name'] : ''
            json_proprietor_name['trust_type']                  = proprietor['name']['trust_format'].present? ? proprietor['name']['trust_format'] : ''
            json_proprietor_name['decoration']                  = proprietor['name']['decoration'].present? ? proprietor['name']['decoration'] : ''
            json_proprietor_name['name_category']               = proprietor['name']['name_category'].present? ? proprietor['name']['name_category'] : ''
            json_proprietor_name['charity_name']                = proprietor['name']['charity_name'].present? ? proprietor['name']['charity_name'] : ''
            json_proprietor_name['local_authority_area']        = proprietor['name']['local_authority_area'].present? ? proprietor['name']['local_authority_area'] : ''
            json_proprietor_name['title']                       = proprietor['name']['title'].present? ? proprietor['name']['title'] : ''
            json_proprietor_name['company_location']            = proprietor['name']['company_location'].present? ? proprietor['name']['company_location'] : ''
            json_proprietor_name['alias_names']                 = get_alias_names(proprietor['name'])

            json_proprietor['addresses']                        = get_addresses(proprietor)
            json_proprietor['name']                             = json_proprietor_name
            json_proprietors.push(json_proprietor)
          end
        end
      end
    end

    json_proprietors
  end

  #return hash of address
  def self.get_addresses(proprietor)
    address_array = []

    if proprietor['addresses'].present?
      proprietor['addresses'].each do |address|
        json_address = populate_address( address )

        address_array.push(json_address) if json_address.present?
      end   #of each address
    end   #of address present

    address_array
  end  # of get address

  def self.populate_address( address )
    json_address = {}

    json_address['full_address']              = address['address_string'].present? ? address['address_string'] : ''
    json_address['house_no']                  = address['house_no'].present? ? address['house_no'] : ''
    json_address['street_name']               = address['street_name'].present? ? address['street_name'] : ''
    json_address['town']                      = address['town'].present? ? address['town'] : ''
    json_address['postal_county']             = address['postal_county'].present? ? address['postal_county'] : ''
    json_address['region_name']               = address['region_name'].present? ? address['region_name'] : ''
    json_address['country']                   = address['country'].present? ? address['country'] : ''
    json_address['postcode']                  = address['postcode'].present? ? address['postcode'] : ''

    json_address['local_name']                = address['local_name'].present? ? address['local_name'] : ''
    json_address['dx_number']                 = address['dx_no'].present? ? address['dx_no'] : ''
    json_address['leading_information']       = address['leading_info'].present? ? address['leading_info'] : ''
    json_address['sub_building_description']  = address['sub_building_description'].present? ? address['sub_building_description'] : ''
    json_address['trailing_information']      = address['trail_info'].present? ? address['trail_info'] : ''
    json_address['sub_building_number']       = address['sub_building_no'].present? ? address['sub_building_no'] : ''
    json_address['house_alpha']               = address['house_alpha'].present? ? address['house_alpha'] : ''
    json_address['plot_no']                   = address['plot_no'].present? ? address['plot_no'] : ''
    json_address['secondary_house_alpha']     = address['secondary_house_alpha'].present? ? address['secondary_house_alpha'] : ''
    json_address['plot_code']                 = address['plot_code'].present? ? address['plot_code'] : ''
    json_address['secondary_house_number']    = address['secondary_house_no'].present? ? address['secondary_house_no'] : ''
    json_address['email_address']             = address['email_address'].present? ? address['email_address'] : ''
    json_address['address_type']              = address['address_type'].present? ? address['address_type'] : ''
    json_address['dx_exchange_name']          = address['exchange_name'].present? ? address['exchange_name'] : ''
    json_address['house_description']         = address['house_description'].present? ? address['house_description'] : ''

    json_address
  end


  # def self.populate_fields( entry )
  #   fields = {}
  #   if entry['infills'].present?
  #     entry['infills'].each do |infill|
  #       type = infill['type'].present? ? infill['type'].downcase : 'miscellaneous'
  #
  #       case type
  #         when 'charge proprietor'
  #           if fields['proprietors'].nil?
  #             fields['proprietors'] = []
  #           end
  #           fields['proprietors'].push( get_proprietor_fields( entry ) )
  #         when 'proprietor'
  #           if fields['proprietors'].nil?
  #             fields['proprietors'] = []
  #           end
  #           fields['proprietors'] = get_proprietor_fields( entry )
  #         when 'address'
  #           fields['addresses'] = populate_address( infill['address'] )
  #         else
  #           if fields[type].nil?
  #             fields[type] = []
  #           end
  #           text = infill['text'].present? ? infill['text'] : ''
  #           fields[type].push( text )
  #       end
  #     end
  #   end
  #
  #   fields
  # end
  #
  # #return hash of proprietor fields (for new bit of JSON)
  # def self.get_proprietor_fields( entry )
  #   json_proprietors = []
  #
  #   if entry['infills'].present?
  #     entry['infills'].each do |infill|
  #       if infill['proprietors'].present?
  #         infill['proprietors'].each do |proprietor|
  #           json_proprietor = {}
  #           json_proprietor_name = {}
  #
  #           json_proprietor_name['title']                       = proprietor['name']['title'].present? ? proprietor['title'] : ''
  #           json_proprietor_name['decoration']                  = proprietor['name']['decoration'].present? ? proprietor['decoration'] : ''
  #           json_proprietor_name['first_name']                  = proprietor['name']['forename'].present? ? proprietor['name']['forename'] : ''
  #           json_proprietor_name['last_name']                   = proprietor['name']['surname'].present? ? proprietor['name']['surname'] : ''
  #           json_proprietor_name['non_private_individual_name'] = proprietor['name']['non_private_individual_name'].present? ? proprietor['name']['non_private_individual_name'] : ''
  #
  #           if json_proprietor_name['non_private_individual_name'] == ''
  #             if json_proprietor_name['first_name'] .present? #check if only a surname is present
  #               json_proprietor_name['full_name'] = json_proprietor_name['first_name'] + ' ' + json_proprietor_name['last_name']
  #             else
  #               json_proprietor_name['full_name'] = json_proprietor_name['last_name']
  #             end
  #           else
  #             json_proprietor_name['full_name']   = json_proprietor_name['non_private_individual_name']
  #           end
  #
  #           json_proprietor_name['country_incorporation']       = proprietor['name']['country_incorporation'].present? ? proprietor['name']['country_incorporation'] : ''
  #           json_proprietor_name['company_registration_number'] = proprietor['name']['company_reg_num'].present? ? proprietor['name']['company_reg_num'] : ''
  #           json_proprietor_name['name_information']            = proprietor['name']['name_information'].present? ? proprietor['name']['name_information'] : ''
  #           json_proprietor_name['occupation']                  = proprietor['name']['name_occupation'].present? ? proprietor['name']['name_occupation'] : ''
  #           json_proprietor_name['name_supplementary']          = proprietor['name']['name_supplimentary'].present? ? proprietor['name']['name_supplimentary'] : ''
  #           json_proprietor_name['trading_name']                = proprietor['name']['trading_name'].present? ? proprietor['name']['trading_name'] : ''
  #           json_proprietor_name['trust_type']                  = proprietor['name']['trust_format'].present? ? proprietor['name']['trust_format'] : ''
  #           json_proprietor_name['decoration']                  = proprietor['name']['decoration'].present? ? proprietor['name']['decoration'] : ''
  #           json_proprietor_name['name_category']               = proprietor['name']['name_category'].present? ? proprietor['name']['name_category'] : ''
  #           json_proprietor_name['charity_name']                = proprietor['name']['charity_name'].present? ? proprietor['name']['charity_name'] : ''
  #           json_proprietor_name['local_authority_area']        = proprietor['name']['local_authority_area'].present? ? proprietor['name']['local_authority_area'] : ''
  #           json_proprietor_name['title']                       = proprietor['name']['title'].present? ? proprietor['name']['title'] : ''
  #           json_proprietor_name['company_location']            = proprietor['name']['company_location'].present? ? proprietor['name']['company_location'] : ''
  #           json_proprietor_name['alias_names']                 = CommonRoutines.get_alias_names(proprietor['name'])
  #
  #           json_proprietor['addresses']                        = get_addresses(proprietor)
  #           json_proprietor['name']                             = json_proprietor_name
  #           json_proprietors.push(json_proprietor)
  #         end
  #       end
  #     end
  #   end
  #
  #   json_proprietors
  # end

  # #return hash of address
  # def self.get_addresses(proprietor)
  #   address_array = []
  #
  #   if proprietor['addresses'].present?
  #     proprietor['addresses'].each do |address|
  #       json_address = populate_address( address )
  #
  #       address_array.push(json_address) if json_address.present?
  #     end   #of each address
  #   end   #of address present
  #
  #   address_array
  # end  # of get address
  #
  # def self.populate_address( address )
  #   json_address = {}
  #
  #   json_address['full_address']              = address['address_string'].present? ? address['address_string'] : ''
  #   json_address['house_no']                  = address['house_no'].present? ? address['house_no'] : ''
  #   json_address['street_name']               = address['street_name'].present? ? address['street_name'] : ''
  #   json_address['town']                      = address['town'].present? ? address['town'] : ''
  #   json_address['postal_county']             = address['postal_county'].present? ? address['postal_county'] : ''
  #   json_address['region_name']               = address['region_name'].present? ? address['region_name'] : ''
  #   json_address['country']                   = address['country'].present? ? address['country'] : ''
  #   json_address['postcode']                  = address['postcode'].present? ? address['postcode'] : ''
  #
  #   json_address['local_name']                = address['local_name'].present? ? address['local_name'] : ''
  #   json_address['dx_number']                 = address['dx_no'].present? ? address['dx_no'] : ''
  #   json_address['leading_information']       = address['leading_info'].present? ? address['leading_info'] : ''
  #   json_address['sub_building_description']  = address['sub_building_description'].present? ? address['sub_building_description'] : ''
  #   json_address['trailing_information']      = address['trail_info'].present? ? address['trail_info'] : ''
  #   json_address['sub_building_number']       = address['sub_building_no'].present? ? address['sub_building_no'] : ''
  #   json_address['house_alpha']               = address['house_alpha'].present? ? address['house_alpha'] : ''
  #   json_address['plot_no']                   = address['plot_no'].present? ? address['plot_no'] : ''
  #   json_address['secondary_house_alpha']     = address['secondary_house_alpha'].present? ? address['secondary_house_alpha'] : ''
  #   json_address['plot_code']                 = address['plot_code'].present? ? address['plot_code'] : ''
  #   json_address['secondary_house_number']    = address['secondary_house_no'].present? ? address['secondary_house_no'] : ''
  #   json_address['email_address']             = address['email_address'].present? ? address['email_address'] : ''
  #   json_address['address_type']              = address['address_type'].present? ? address['address_type'] : ''
  #   json_address['dx_exchange_name']          = address['exchange_name'].present? ? address['exchange_name'] : ''
  #   json_address['house_description']         = address['house_description'].present? ? address['house_description'] : ''
  #
  #   json_address
  # end

end