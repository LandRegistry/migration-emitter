require_relative 'common_routines'

class DataExtractor
  def self.extract_entry( entry )
    json_entry           = CommonRoutines.set_up_entry( entry )
    json_entry['fields'] = populate_fields( entry )

    json_entry
  end

  #return hash of property description
  def self.get_property_description( entry )
    property           = CommonRoutines.set_up_entry( entry )
    property['fields'] = populate_fields( entry )

    property
  end


  def self.populate_fields( entry )
    fields = {}
    if entry['infills'].present?
      entry['infills'].each do |infill|
        type = infill['type'].present? ? infill['type'].downcase : 'miscellaneous'

        # if fields[type].nil?
        #   fields[type] = []
        # end

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

  #return a hash containing price paid information
  def self.get_price_paid( entry )
    price_paid            = CommonRoutines.set_up_entry( entry )
    price_paid['fields']  = populate_fields( entry )

    price_paid
  end

  #return a hash containing proprietorship information
  def self.get_proprietorship( entry )
    proprietorship            = CommonRoutines.set_up_entry( entry )
    proprietorship['fields']  = get_proprietor_fields( entry )

    proprietorship
  end

  #return hash of proprietor fields (for new bit of JSON)
  def self.get_proprietor_fields( entry )
    #fields = {}
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
            json_proprietor_name['alias_names']                 = CommonRoutines.get_alias_names(proprietor['name'])

            json_proprietor['addresses']                        = get_addresses(proprietor)
            json_proprietor['name']                             = json_proprietor_name
            json_proprietors.push(json_proprietor)
          end
        end
      end
    end

    json_proprietors
    #fields['proprietors'] = json_proprietors
    #return fields
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

end