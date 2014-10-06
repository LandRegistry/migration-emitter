require_relative 'common_routines'

class ScheduleExtractor
  def self.get_schedules( model )
    schedules = {}
    schedules['D'] = []
    schedules['E'] = []
    schedules['F'] = []
    schedules['H'] = []
    schedules['L'] = []
    schedules['M'] = []
    schedules['P'] = []
    schedules['Q'] = []
    schedules['R'] = []
    schedules['T'] = []
    schedules['W'] = []
    schedules['X'] = []
    schedules['Y'] = []
    schedules['Z'] = []

    if model['entries'].present?
      model['entries'].detect do |entry|

        case entry['role_code']
          when 'DIRC' #D
            schedule_entry = setup_schedule_entry( entry )
            schedule_entry['template'] = 'Plan reference: *S1* Nature of deed: *S2* Date of deed: *S3* Parties: *S4* *S<Remarks:>5*'
            fields = {}
            fields['plans_reference'] = find_fields(entry, 'Plans reference')
            fields['nature_of_deed']  = find_fields(entry, 'Nature of deed')
            fields['date_of_deed']    = find_fields(entry, 'Date of deed')
            fields['parties']         = extract_parties( entry )
            fields['remarks']         = find_optional_fields(entry, 'Remarks')

            schedule_entry['fields'] = fields
            schedules['D'].push(schedule_entry) if schedule_entry

          when 'SSCH' #E/S  ???????????

          when 'RFEA' #F
            schedule_entry = setup_schedule_entry( entry )
            schedule_entry['template'] = 'Benefitting land: *S1* *S<Title Number of benefiting land:>2* Date of lease: *S3* Term of lease: *S4* *S<Registration date:>5*'
            fields = {}
            fields['benefiting_land']   = find_fields(entry, 'Benefitting land')
            fields['title_number']      = find_optional_fields(entry, 'Title Number of benefitting land')
            fields['date_of_lease']     = find_fields(entry, 'Date of lease')
            fields['term_of_lease']     = find_fields(entry, 'Term of lease')
            fields['registration_date'] = find_optional_fields(entry, 'Registration date')

            schedule_entry['fields'] = fields
            schedules['F'].push(schedule_entry) if schedule_entry

          when 'RSLP' #H
            schedule_entry = setup_schedule_entry( entry )
            schedule_entry['template'] = 'Short particulars of the lease(s) (or under-lease(s)) under which the land is held: Date: *S1* Term: *S2* *S<Rent:>3* Parties: *S4*'
            fields = {}
            fields['date_of_deed']    = find_fields(entry, 'Date')
            fields['term']            = find_fields(entry, 'Term')
            fields['rent']            = find_optional_fields(entry, 'Rent')
            fields['parties']         = extract_parties( entry )

            schedule_entry['fields'] = fields
            schedules['H'].push(schedule_entry) if schedule_entry

          when 'RLLE' #L
            schedule_entry = setup_schedule_entry( entry )
            schedule_entry['template'] = 'Benefitting land: *S1* *S<Title Number of benefiting land:>2* Date of lease: *S3* Term of lease: *S4* *S<Registration date:>5*'
            fields = {}
            fields['benefiting_land']   = find_fields(entry, 'Benefitting land')
            fields['title_number']      = find_optional_fields(entry, 'Title Number of benefitting land')
            fields['date_of_lease']     = find_fields(entry, 'Date of lease')
            fields['term_of_lease']     = find_fields(entry, 'Term of lease')
            fields['registration_date'] = find_optional_fields(entry, 'Registration date')

            schedule_entry['fields'] = fields
            schedules['L'].push(schedule_entry) if schedule_entry

          when 'RMRL' #M
          when 'PMPS' #P
          when 'RWDF' #Q
          when 'DMRR' #R
          when 'RSAR' #T
          when 'RWRN' #W
          when 'XSCH' #X  ????????????
          when 'RWAP' #Y
          when 'DRTP' #Z
          else
        end
      end
    end

    schedules
  end

  def self.find_fields( entry, header )
    return (entry['schedule']['fields'].find{|fields| fields['header'] == header})['text']
  end

  def self.find_optional_fields( entry, header )
    text = ''
    (entry['schedule']['fields'].find{|fields| fields['header'] == header}).nil? ? '' : text = (entry['schedule']['fields'].find{|fields| fields['header'] == header})['text']

    return text
  end

  def self.setup_schedule_entry( entry )
    schedule_entry = {}
    schedule_entry['header']          = entry['schedule']['header'].present? ? entry['schedule']['header'] : ''
    schedule_entry['deed']            = CommonRoutines.get_deeds( entry )  #TODO - get deeds for schedules
    schedule_entry['notes']           = CommonRoutines.get_notes( entry )
    schedule_entry['full_text']       = '' #TODO - get full text
    schedule_entry['entry_date']      = entry['entry_date'].present? ? entry['entry_date'] : ''
    schedule_entry['role_code']       = entry['role_code'].present? ? entry['role_code'] : ''
    schedule_entry['status']          = entry['status'].present? ? entry['status'] : ''
    schedule_entry['lang_code']       = entry['language'].present? ? entry['language'] : ''
    schedule_entry['parent_register'] = entry['schedule']['parent_register'].present? ? entry['schedule']['parent_register'] : ''

    schedule_entry
  end

  def self.extract_parties( entry )
    parties = entry['schedule']['fields'].find{|fields| fields['header'] == 'Parties'}
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

        if party_name['non_private_individual_name'].present?
          name_text = name_text + separator + party_name['non_private_individual_name']
        else
          name_text = name_text + separator + party_name['forename'] + ' ' + party_name['surname']
        end
      end

      party_text = party_text + party_number + name_text
    end

    party_text.strip
  end

end