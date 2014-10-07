class CommonRoutines

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