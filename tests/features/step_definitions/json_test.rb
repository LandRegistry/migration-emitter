When(/^I get the JSON$/) do
  mrc = MigrateRegisterConsumer.new
  title = 'BK508401' #obviously change this as required
  m = mrc.migrate_register('{"title_number":"' + title + '"}')
  mec = MintEmitterConsumer.new
  @last_json = mec.process_message(m)

end
