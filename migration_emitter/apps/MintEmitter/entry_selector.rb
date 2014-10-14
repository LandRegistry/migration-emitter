require 'active_support/all'
require_relative '../MintEmitter/data_extractor'
require_relative '../MintEmitter/schedule_extractor'
require 'pp'
require 'yaml'

class EntrySelector

  EASEMENTS             = ['DAEA', 'RKHL', 'DANP', 'RGEP', 'RCEA', 'DCEA', 'RHQH']
  RESTRICTIVE_COVENANTS = ['DARC', 'DCOV', 'RCOV']
  PROVISIONS            = ['DPRO']
  CHARGES               = ['CCHA', 'CCHR']
  RESTRICTIONS          = ['ORES', 'CBCR', 'OJPR']
  BANKRUPTCY            = ['OBAN', 'ORED', 'OCRD']
  PRICE_PAID            = ['RPPD']
  SCHEDULES             = ['DIRC', 'SSCH', 'RFEA', 'RSLP', 'RLLE', 'RMRL', 'PMPS', 'RWDF', 'DMRR', 'RSAR', 'RWRN', 'XSCH', 'RWAP', 'DRTP']
  PROPRIETORSHIP        = ['RCAU', 'RPRO']
  PROPERTY_DESCRIPTION  = ['RDES', 'RMRL', 'PMPS']

  def self.extract_all_entries( model )
    entries_list = initilise_entries_list

    if model['entries'].present?

      model['entries'].each do |entry|

        case entry['role_code']

          when *PROPERTY_DESCRIPTION
            if entries_list['property_description'].empty?
              entries_list['property_description'] = DataExtractor.extract_entry( entry )
            else
              #raise 'multiple property descriptions found'   #TODO - we need to deal with valid multiple descriptions (M and P scheds)
            end

          when *PROPRIETORSHIP
            if entries_list['proprietorship'].empty?
              entries_list['proprietorship'] = DataExtractor.extract_entry( entry )
            else
              raise 'multiple proprietorships found'
            end

          when *CHARGES
            entries_list['charges'].push( DataExtractor.extract_entry( entry ) )

          when *EASEMENTS
            entries_list['easements'].push( DataExtractor.extract_entry( entry ) )

          when *RESTRICTIVE_COVENANTS
            entries_list['restrictive_covenants'].push( DataExtractor.extract_entry( entry ) )

          when *PROVISIONS
            entries_list['provisions'].push( DataExtractor.extract_entry( entry ) )

          when *PRICE_PAID
            if entries_list['price_paid'].nil?
              entries_list['price_paid'] = DataExtractor.extract_entry( entry )
            else
              raise 'multiple price paid entries found'
            end

          when *RESTRICTIONS
            entries_list['restrictions'].push( DataExtractor.extract_entry( entry ) )

          when *BANKRUPTCY
            entries_list['bankruptcy'].push( DataExtractor.extract_entry( entry ) )

          when 'DIRC'
            entries_list['d_schedule'].push( ScheduleExtractor.extract_schedule_entry( entry ) )

          when 'SSCH'
            entries_list['e_schedule'].push( ScheduleExtractor.extract_schedule_entry( entry ) )

          when 'RFEA'
            entries_list['f_schedule'].push( ScheduleExtractor.extract_schedule_entry( entry ) )

          when 'RSLP'
            if entries_list['h_schedule'].nil?
              entries_list['h_schedule'] = ScheduleExtractor.extract_schedule_entry( entry )
            else
              raise 'multiple h schedules found'
            end

          when 'RLLE'
            entries_list['l_schedule'].push( ScheduleExtractor.extract_schedule_entry( entry )  )

          when 'RMRL'
            entries_list['m_schedule'].push( ScheduleExtractor.extract_schedule_entry( entry )  )

          when 'PMPS'
            entries_list['p_schedule'].push( ScheduleExtractor.extract_schedule_entry( entry )  )

          when 'RWDF'
            entries_list['q_schedule'].push( ScheduleExtractor.extract_schedule_entry( entry )  )

          when 'DMRR'
            entries_list['r_schedule'].push( ScheduleExtractor.extract_schedule_entry( entry )  )

          when 'RSAR'
            entries_list['t_schedule'].push( ScheduleExtractor.extract_schedule_entry( entry )  )

          when 'RWRN'
            entries_list['w_schedule'].push( ScheduleExtractor.extract_schedule_entry( entry )  )

          when 'XSCH'
            entries_list['x_schedule'].push( ScheduleExtractor.extract_schedule_entry( entry )  )

          when 'RWAP'
            entries_list['y_schedule'].push( ScheduleExtractor.extract_schedule_entry( entry )  )

          when 'DRTP'
            entries_list['z_schedule'].push( ScheduleExtractor.extract_schedule_entry( entry )  )

          else #put remainder in other section
           entries_list['other'].push( DataExtractor.extract_entry( entry ) )

        end  #case role code
      end  #each entry
    else
      raise 'title has no extracted entries'
    end

    entries_list
  end

  #initialise all the required arrays and hashes for the model (h_schedule and price paid are created on demand)
  def self.initilise_entries_list
    entries_list = {}

    json_hash_sections = ['property_description', 'proprietorship']
    json_array_sections = ['charges', 'easements', 'restrictive_covenants', 'provisions', 'restrictions', 'bankruptcy',
                           'd_schedule', 'e_schedule', 'f_schedule', 'l_schedule', 'm_schedule', 'p_schedule',
                           'q_schedule', 'r_schedule', 't_schedule', 'w_schedule', 'x_schedule', 'y_schedule',
                           'z_schedule', 'other']

    json_hash_sections.each do |section|
      entries_list[section] = {}
    end

    json_array_sections.each do |section|
      entries_list[section] = []
    end

    entries_list
  end #extract all entries


end #EntrySelector class




# model = YAML.load(File.read('/usr/src/land_reg/migration-emitter/tests/test_registers/dflwy.yml'))
# pp EntrySelector.extract_all_entries(model)


# model = {}
# model['entries'] = []
# entry = {}
# entry['role_code'] = 'CCHA'
# model['entries'].push(entry)
# EntrySelector.extract_all_entries(model)