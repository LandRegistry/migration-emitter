require_relative '../MintEmitter/data_extractor'

class ScheduleExtractor

  def self.extract_schedule_entry( entry )
    schedule_entry = setup_schedule_entry( entry )
    fields = {}

    case entry['role_code']
      when 'DIRC'  #D
        schedule_entry['template'] = 'Plan reference: *S1* Nature of deed: *S2* Date of deed: *S3* Parties: *S4* *S<Remarks:>5*'
        fields['plans_reference']  = find_fields(entry, 'Plans reference')
        fields['nature_of_deed']   = find_fields(entry, 'Nature of deed')
        fields['date_of_deed']     = find_fields(entry, 'Date of deed')
        fields['parties']          = extract_parties( entry, 'Parties' )
        fields['remarks']          = find_optional_fields(entry, 'Remarks')

      when 'SSCH' #E
        schedule_entry['template']  = entry['template_text']
        schedule_entry['fields']    = DataExtractor.populate_fields( entry )

      when 'RFEA' #F
        schedule_entry['template']  = 'Benefitting land: *S1* *S<Title Number of benefiting land:>2* Date of lease: *S3* Term of lease: *S4* *S<Registration date:>5*'
        fields['benefiting_land']   = find_fields(entry, 'Benefiting land')
        fields['title_number']      = find_optional_fields(entry, 'Title Number of benefiting land')
        fields['date_of_lease']     = find_fields(entry, 'Date of lease')
        fields['term_of_lease']     = find_fields(entry, 'Term of lease')
        fields['registration_date'] = find_optional_fields(entry, 'Registration date')
      when 'RSLP' #H
        schedule_entry['template']  = 'Short particulars of the lease(s) (or under-lease(s)) under which the land is held: Date: *S1* Term: *S2* *S<Rent:>3* Parties: *S4*'
        fields['date_of_deed']      = find_fields( entry, 'Date' )
        fields['term']              = find_fields( entry, 'Term' )
        fields['rent']              = find_optional_fields( entry, 'Rent' )
        fields['parties']           = extract_parties( entry, 'Parties' )
       when 'RLLE' #L
        schedule_entry['template']    = '*S<Registration Date:>1* *S<Plan Reference:>2* Property Description: *S3* Date of Lease: *S4* Term: *S5* *S<Lessee''s Title:>6*'
        fields['registration_date']   = find_optional_fields(entry, 'Registration Date')
        fields['plan_reference']      = find_optional_fields(entry, 'Plan Reference')
        fields['property_description']= find_fields(entry, 'Property Description')
        fields['date_of_lease']       = find_fields(entry, 'Date of Lease')
        fields['term']                = find_fields(entry, 'Term')
        fields['lessees_title']       = find_optional_fields(entry, 'Lessees Title')

      when 'RMRL' #M
        schedule_entry['template']      = 'Property description: *S1* Date of lease: *S2* Parties: *S3* Term: *S4* *S<Rent:>5* *S<Lessor''s title:>6* *S<Plan reference:>7*'
        fields['property_description']  = find_fields(entry, 'Property description')
        fields['date_of_lease']         = find_fields(entry, 'Date of lease')
        fields['parties']               = extract_parties( entry, 'Parties' )
        fields['term']                  = find_fields(entry, 'Term')
        fields['rent']                  = find_optional_fields(entry, 'Rent')
        fields['lessors_title']         = find_optional_fields(entry, 'Lessor''s title')
        fields['plan_reference']        = find_optional_fields(entry, 'Plan reference')

      when 'PMPS' #P
        schedule_entry['template']      = 'Short description: *S1* Plan reference: *S2*'
        fields['short_description']     = find_fields(entry, 'Short description')
        fields['plan_reference']        = find_fields(entry, 'Plan reference')

      when 'RWDF' #Q
        schedule_entry['template']  = 'The leasehold land out of which the registered rentcharge issues is held under a lease of which the following are short particulars and the registered rentcharge is subject to all obligations and liabilities incident to the said leasehold term: Date of Lease: *S1* Term: *S2* Parties: *S3*'
        fields['date_of_lease']     = find_fields(entry, 'Date of Lease')
        fields['term']              = find_fields(entry, 'Term')
        fields['parties']           = extract_parties( entry, 'Parties' )

      when 'DMRR' #R
        schedule_entry['template']      = 'Rentcharge sum: *S1* Payable on: *S2* Property description: *S3* Title No under which land is registered: *S4* Nature of deed: *S5* Date of deed: *S6* Parties: *S7* *S<Remarks:>8* *S<Plan Reference>9*'
        fields['rentcharge_sum']        = find_fields(entry, 'Rentcharge sum')
        fields['payable_on']            = find_fields(entry, 'Payable on')
        fields['property_description']  = find_fields(entry, 'Property description')
        fields['title_no']              = find_fields(entry, 'Title No under which land is registered')
        fields['nature_of_deed']         = find_fields(entry, 'Nature of deed')
        fields['date_of_deed']          = find_fields(entry, 'Date of deed')
        fields['parties']               = extract_parties( entry, 'Parties' )
        fields['remarks']               = find_optional_fields(entry, 'Remarks')
        fields['plan_reference']        = find_optional_fields(entry, 'Plan Reference')

      when 'RSAR' #T
        schedule_entry['template']      = 'Property description: *S1* Apportioned rent: *S2* Parties: *S3* Title No.under which land is registered: *S4* *S<Registration date:>5*'
        fields['property_description']  = find_fields(entry, 'Property description')
        fields['rent']                  = find_fields(entry, 'Apportioned rent')
        fields['date_of_transfer']      = find_fields(entry, 'Date of Transfer')
        fields['parties']               = extract_parties( entry, 'Parties' )
        fields['title_no']              = find_fields(entry, 'Title No under which land is registered')
        fields['registration_date']     = find_optional_fields(entry, 'Registration date')

      when 'RWRN' #W
        schedule_entry['template']      = 'Description of land: *S1* Rentcharge: *S2* Nature of deed: *S3* Date of deed: *S4* *S<Remarks:>5* *S<Registration date:>6*'
        fields['description_of_land']   = find_fields(entry, 'Description of land')
        fields['rentcharge']            = find_fields(entry, 'Rentcharge')
        fields['nature_of_deed']        = find_fields(entry, 'Nature of deed')
        fields['date_of_deed']          = find_fields(entry, 'Date of deed')
        fields['remarks']               = find_optional_fields(entry, 'Remarks')
        fields['registration_date']     = find_optional_fields(entry, 'Registration date')

      when 'XSCH' #X
        schedule_entry['template']  = entry['template_text']
        schedule_entry['fields']    = DataExtractor.populate_fields( entry )

      when 'RWAP' #Y
        schedule_entry['template']      = 'Improved or apportioned rentcharge: *S1* Property description: *S2* Nature of deed: *S3* Date of deed: *S4* *S<Remarks:>5* *S<Registration date:>6*'
        fields['description_of_land']   = find_fields(entry, 'Improved or apportioned rentcharge')
        fields['rentcharge']            = find_fields(entry, 'Property description')
        fields['nature_of_deed']        = find_fields(entry, 'Nature of deed')
        fields['date_of_deed']          = find_fields(entry, 'Date of deed')
        fields['remarks']               = find_optional_fields(entry, 'Remarks')
        fields['registration_date']     = find_optional_fields(entry, 'Registration date')

      when 'DRTP' #Z
        schedule_entry['template']      = 'Rentcharge sum: *S1* Payable on: *S2* Land out of which rentcharge issues: *S3* Date of Transfer: *S4* Name of Transferee: *S5* *S<Title No.under which land is registered:>6* *S<Plan reference:>7* *S<Registration date:>8*'
        fields['rentcharge_sum']                      = find_fields(entry, 'Rentcharge sum')
        fields['payable_on']                          = find_fields(entry, 'Payable on')
        fields['land_out_of_which_rentcharge_issues'] = find_fields(entry, 'Land out of which rentcharge issues')
        fields['date_of_transfer']                    = find_fields(entry, 'Date of Transfer')
        fields['name_of_transferee']                  = extract_parties( entry, 'Name of Transferee' )
        fields['title_number']                        = find_fields(entry, 'Title No.under which land is registered')
        fields['plan_reference']                      = find_optional_fields(entry, 'Plan reference')
        fields['registration_date']                   = find_optional_fields(entry, 'Registration date')
      else
        raise 'entry does not have a known schedule role code'
    end

    schedule_entry['fields']  = fields
    schedule_entry
  end


  def self.find_fields( entry, header )
    if entry['schedule'].present?
      field = entry['schedule']['fields'].find{|fields| fields['header'] == header}

      if field['text'].present?
        return field['text'].strip
      else
        raise 'mandatory schedule field not present'
      end
    end
  end

  def self.find_optional_fields( entry, header )
    text = ''
    if entry['schedule'].present?
      (entry['schedule']['fields'].find{|fields| fields['header'] == header}).nil? ? '' : text = (entry['schedule']['fields'].find{|fields| fields['header'] == header})['text']
    end
    return text
  end


  def self.setup_schedule_entry( entry )
    schedule_entry = DataExtractor.set_up_entry( entry )
    schedule_entry['header']          = entry['schedule']['header'].present? ? entry['schedule']['header'] : ''
    schedule_entry['parent_register'] = entry['schedule']['parent_register'].present? ? entry['schedule']['parent_register'] : ''

    schedule_entry
  end


  def self.extract_parties( entry, header )
    parties = entry['schedule']['fields'].find{|fields| fields['header'] == header}
    party_text = ''

    parties['parties'].each_with_index do |party, index|
      if parties['parties'].count > 1
        party_number = ' (' + (index + 1).to_s + ') '
      else
        party_number = ''
      end

      names_in_party = party['names'].count
      name_text = ''

      party['names'].each_with_index do |party_name, index|
        if index == 0
          separator = ''
        else
          if index == names_in_party - 1
            separator = ' and '
          else
            separator = ', '
          end
        end

        if party_name['non_private_individual_name'].present? && (party_name['forename'].present? || party_name['surname'].present? )
          raise 'party information found in both non private individual fields and private individual fields'
        end

        if party_name['non_private_individual_name'].nil? && party_name['forename'].nil? && party_name['surname'].nil?
          raise 'no name information found for party'
        end

        if party_name['non_private_individual_name'].present?  #use correct name type
          name_text = name_text + separator + party_name['non_private_individual_name']
        else
          if party_name['forename'].present? #check if only a surname is present
            if party_name['surname'].present? #ensure forename and surname are present
              name_text = name_text + separator + party_name['forename'] + ' ' + party_name['surname']
            else
              raise 'party found with forename but no surname for entry ' + entry['entry_id']
            end
          else
            pp party_name
            pp entry['entry_id']
            name_text = name_text + separator + party_name['surname']
          end
        end
      end

      party_text = party_text + party_number + name_text
    end

    party_text.strip
  end

end