require 'jbuilder'
# require_relative '../MintEmitter/data_extractor'
# require_relative '../MintEmitter/schedule_extractor'
require_relative '../../apps/MintEmitter/entry_selector'

class JSONBuilder

  def self.convert_hash(model)

    entry_list = EntrySelector.extract_all_entries( model )

    output = Jbuilder.encode do |json|
      #json.ignore_nil! true

      json.title_number           model['title_number'] if model['title_number']
      json.extent                 model['geometry']['extent'] if model['geometry'] && model['geometry']['extent']
      json.tenure                 model['class'] if model['class']
      json.class_of_title         model['tenure'] if model['tenure']
      json.edition_date           model['edition_date'] if model['edition_date']
      json.last_application       model['last_app_timestamp'] if model['last_app_timestamp']
      json.office                 model['office'] if model['office']
      json.districts              model['districts'] if model ['districts']
      json.proprietorship         entry_list['proprietorship']
      json.property_description   entry_list['property_description']

      #only show price paid in json if present
      price_paid = entry_list['price_paid']
      if price_paid.present?
        json.price_paid           price_paid
      end

      json.provisions             entry_list['provisions']
      json.easements              entry_list['easements']
      json.restrictive_covenants  entry_list['restrictive_covenants']
      json.restrictions           entry_list['restrictions']
      json.bankruptcy             entry_list['bankruptcy']
      json.charges                entry_list['charges']
      json.d_schedule             entry_list['d_schedule']
      #json.e_schedule             entry_list['e_schedule']
      json.f_schedule             entry_list['f_schedule']

      #only show h schedule in json if present
      h_schedule = entry_list['h_schedule']
      if h_schedule.present?
        json.h_schedule           h_schedule
      end

      json.l_schedule             entry_list['l_schedule']
      json.m_schedule             entry_list['m_schedule']
      json.p_schedule             entry_list['p_schedule']
      json.q_schedule             entry_list['q_schedule']
      json.r_schedule             entry_list['r_schedule']
      json.t_schedule             entry_list['t_schedule']
      json.w_schedule             entry_list['w_schedule']
      #json.x_schedule             entry_list['x_schedule']
      json.y_schedule             entry_list['y_schedule']
      json.z_schedule             entry_list['z_schedule']

      json.other                  entry_list['other']
    end #of encode

    return output

  end

end