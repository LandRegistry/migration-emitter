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

          when 'SSCH' #E/S  ???????????
          when 'RFEA' #F
          when 'RSLP' #H
            schedule_entry = setup_schedule_entry
            schedule_entry['template'] = 'Short particulars of the lease(s) (or under-lease(s)) under which the land is held: Date:*S1* Term:*S2* *S<Rent:>3* Parties:*S4*'
          when 'RLLE' #L
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

  def self.setup_schedule_entry
    schedule_entry = {}
    schedule_entry['header']  = entry['schedule']['header']
    schedule_entry['deed']    = CommonRoutines.get_deeds( entry )
    schedule_entry['notes']   = CommonRoutines.get_notes( entry )
    schedule_entry['full_text'] = '' #TODO - get full text
  end

end