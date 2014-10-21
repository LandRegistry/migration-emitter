require 'torquebox-messaging'
require 'active_support'
require 'rest_client'
require 'json'
require 'yaml'
require_relative 'json_builder.rb'
require 'pp'

class MintEmitterConsumer < TorqueBox::Messaging::MessageProcessor
	def initialize(url = nil)
		@logger = TorqueBox::Logger.new( self.class )
		ENV['RACK_ENV'] ||= 'development'
		if url.nil?
			@url = YAML.load( File.open(File.dirname(__FILE__) + '/config/mintconfig.yml') )[ENV['RACK_ENV']]["mint_endpoint"]
		else
			@url = url
		end
	end

  #consume the message from the queue and publish if successful
	def on_message(body)
    @body = body
		hash_message = process_message(body)
		post_message(hash_message)
		queue = TorqueBox.fetch('/queues/mint_submit_completed')
    hash = {}
    hash['title_number'] = JSON.parse(hash_message)['title_number']
		hash['submitted_at'] = Time.now.to_s
		queue.publish hash.to_json
    @logger.info( 'Mint submission complete: ' + hash['title_number'] + " at " + hash['submitted_at'] )
  end

  #process the hash and convert to json ready to submit
	def process_message(body)
    if !body['original_message'].nil?
      @body = body['original_message']
      body = @body
      begin
        title = body['title_number']
      rescue
        title = 'N/A'
      end
      @logger.info("Resubmitted Message detected: " + title)
    end
    if !body.is_a? Hash
      raise 'Body not Hash'
    end
    if body['title_number'].nil?
      raise 'No title number in Hash'
    end
    title = body['title_number']
    @logger.info("Mint submission started: " + title)

    json = JSONBuilder.convert_hash(body)

		return json
	end

  #submit message to the mint
	def post_message(message)
    title_no = JSON.parse(message)['title_number']
		RestClient.post(@url + title_no, message, :content_type => :json, :accept => :json) { |response, request, result, &block|
			if response.code != 201
				raise "Mint post failed with response code: " + response.code.to_s + " Response: " + response
			end
			response
		}
	end
  
	def on_error(exception)
		#log error
    begin
      title = @body['title_number']
    rescue
      title = 'N/A'
    end
		@logger.error("Mint Submission failure: " + title + "\n" + exception.to_s + "\n" + exception.backtrace.join("\n"))
		#create error message from failed message body
		error_message = {}
		error_message['original_message'] = @body
		error_message['error_message'] = exception.to_s
		queue = TorqueBox.fetch('/queues/mint_submit_error')
		queue.publish(error_message)
	end

end

# # ##------------ TO RUN UNIT IN ISOLATION UNCOMMENT BELOW ----------------------------
# mec = MintEmitterConsumer.new
# model = YAML.load(File.read('/usr/src/land_reg/migration-emitter/tests/test_registers/DT160760.yml'))
# JSON.parse( mec.process_message(model) )

#write json file
#File.open('AGL29061.json', 'w') {|f| f.puts mec.process_message(model)}

#xxxxxxxxx  --- create new test model and save ---------- xxxxxxxxxxxxx
#require_relative '../../../../MigrateRegister/apps/Migrator/migrate_register_consumer.rb'
# mrc = MigrateRegisterConsumer.new
# # #title_array = ['GR504898', 'CYM200', 'LA353080', 'DT502816', 'WK500527', 'ST500377', 'K789138', 'DT506189', 'BD161881']
# title_array = ['BD161892','BD161873','BD161872','BD161871','BD161870','BD161882','BD161881']    #SAMPLE TITLES
# # title_array = ['BK507906', 'DT160760']
# #title_array = ['BK500521']
# mec = MintEmitterConsumer.new
# title_array.each do |title|
#   begin
#     m = mrc.migrate_register('{"title_number":"' + title + '"}')
#     File.open(title + '.yml', 'w') { |fo| fo.puts m.to_yaml }
#     model = YAML.load_file(title + '.yml')
#      #pp JSON.parse( mec.process_message(model) )
#     File.open(title + '.json', 'w') {|f| f.puts mec.process_message(model)}
#   rescue => e
#     puts e
#   end
# end


