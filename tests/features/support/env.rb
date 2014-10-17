require 'json_spec/cucumber'
require_relative '../../../../MigrateRegister/apps/Migrator/migrate_register_consumer.rb'
require_relative '../../../../migration-emitter/migration_emitter/apps/MintEmitter/mint_emitter_consumer'

def last_json
  @last_json.to_s
end