require_relative 'common_routines'

class DataExtractor

  #return a hash containing bankruptcy entries
  def self.get_bankruptcy( model )
    bankruptcy_array = []

    if model['entries'].present?
      model['entries'].detect do |entry|
        if %w(CBAN CRED OBAN OBIB ORED OSMH).include? entry['role_code']
          bankruptcy['template']    = entry['template_text'].present? ? entry['template_text'] : ''
          bankruptcy['full_text']   = ''  #TODO - extract full text into model
          bankruptcy['fields']      = ''
          bankruptcy['deeds']       = get_deeds( entry )
          bankruptcy['notes']       = get_notes( entry )

          bankruptcy_array.push(bankruptcy)
        end
      end
    end

    bankruptcy_array
  end

  #return a hash containing price paid information
  def self.get_price_paid( model )
    price_paid = {}

    if model['entries'].present?
      model['entries'].detect do |entry|
        if entry['role_code'] == 'RPPD'
          price_paid['template']    = entry['template_text'].present? ? entry['template_text'] : ''
          price_paid['full_text']   = ''  #TODO - extract full text into model
          price_paid['fields']      = ''
          price_paid['deeds']       = get_deeds( entry )
          price_paid['notes']       = get_notes( entry )
        end
      end
    end

    price_paid
  end

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
            json_proprietor_name = {}

            json_proprietor_name['title']                       = proprietor['title'].present? ? proprietor['title'] : ''
            json_proprietor_name['decoration']                  = proprietor['decoration'].present? ? proprietor['decoration'] : ''
            json_proprietor_name['first_name']                  = proprietor['name']['forename'].present? ? proprietor['name']['forename'] : ''
            json_proprietor_name['last_name']                   = proprietor['name']['surname'].present? ? proprietor['name']['surname'] : ''
            json_proprietor_name['non_private_individual_name'] = proprietor['name']['non_private_individual_name'].present? ? proprietor['name']['non_private_individual_name'] : ''

            if json_proprietor_name['non_private_individual_name'] == ''
              json_proprietor_name['full_name']                 = json_proprietor_name['first_name'] + ' ' + json_proprietor_name['last_name']
            else
              json_proprietor_name['full_name']                 = json_proprietor_name['non_private_individual_name']
            end

            json_proprietor_name['country_incorporation']       = proprietor['name']['country_incorporation'].present? ? proprietor['name']['country_incorporation'] : ''
            json_proprietor_name['company_registraion_number']  = proprietor['name']['company_reg_num'].present? ? proprietor['name']['company_reg_num'] : ''
            json_proprietor_name['name_information']            = proprietor['name']['name_information'].present? ? proprietor['name']['name_information'] : ''
            json_proprietor_name['occupation']                  = proprietor['name']['name_occupation'].present? ? proprietor['name']['name_occupation'] : ''
            json_proprietor_name['name_supplimentary']          = proprietor['name']['name_supplimentary'].present? ? proprietor['name']['name_supplimentary'] : ''
            json_proprietor_name['trading_name']                = proprietor['name']['trading_name'].present? ? proprietor['name']['trading_name'] : ''
            json_proprietor_name['trust_type']                  = proprietor['name']['trust_format'].present? ? proprietor['name']['trust_format'] : ''
            json_proprietor_name['decoration']                  = proprietor['name']['decoration'].present? ? proprietor['name']['decoration'] : ''
            json_proprietor_name['name_category']               = proprietor['name']['name_category'].present? ? proprietor['name']['name_category'] : ''
            json_proprietor_name['charity_name']                = proprietor['name']['charity_name'].present? ? proprietor['name']['charity_name'] : ''
            json_proprietor_name['local_authority_area']        = proprietor['name']['local_authority_area'].present? ? proprietor['name']['local_authority_area'] : ''
            json_proprietor_name['first_name']                  = proprietor['name']['title'].present? ? proprietor['name']['title'] : ''
            json_proprietor_name['first_name']                  = proprietor['name']['company_location'].present? ? proprietor['name']['company_location'] : ''
            json_proprietor_name['alias_names']                 = CommonRoutines.get_alias_names(proprietor['name'])

            json_proprietor['addresses']                        = get_addresses(proprietor)
            json_proprietor['name']                             = json_proprietor_name
            json_proprietors.push(json_proprietor)
          end
        end
      end
    end

    fields['proprietors'] = json_proprietors
    return fields
  end

  #return hash of address
  def self.get_addresses(proprietor)
    address_array = []

    if proprietor['addresses'].present?
      proprietor['addresses'].each do |address|
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


end