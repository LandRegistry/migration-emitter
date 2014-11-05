require 'pp'

When(/^I get the JSON$/) do
  mrc = MigrateRegisterConsumer.new
  title = 'BK508401' #obviously change this as required
  m = mrc.migrate_register('{"title_number":"' + title + '"}')
  mec = MintEmitterConsumer.new
  @last_json = mec.process_message(m)
end

Given(/^I get the JSON for title "([^"]*)"$/) do |arg|
  mrc = MigrateRegisterConsumer.new
  m = mrc.migrate_register('{"title_number":"' + arg + '"}')
  mec = MintEmitterConsumer.new
  @last_json = mec.process_message(m)
  pp @last_json
end