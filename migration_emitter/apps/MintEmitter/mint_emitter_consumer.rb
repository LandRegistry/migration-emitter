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
		hash = process_message(body)
		body = post_message(hash)
		queue = TorqueBox.fetch('/queues/mint_submit_completed')
		hash['submitted_at'] = Time.now
		hash.delete('body')
		queue.publish ActiveSupport::JSON.encode(hash)
	end

  #process the hash and convert to json ready to submit
	def process_message(body)
    pp body
		if !body.is_a? Hash
			raise 'Body not Hash'
		end
		@body = body
		if !body['original_message'].nil?
			@body = body['original_message']
			body = @body
			if !body.is_a? Hash
				raise 'Body not Hash'
			end
		end
		if body['title_number'].nil?
			raise 'No title number in JSON'
		end

    json = JSONBuilder.convert_hash(body)

		return json
	end

  #submit message to the mint
	def post_message(message)
		RestClient.post(@url + message['title_number'], message['body'], :content_type => :json, :accept => :json) { |response, request, result, &block|
			if response.code != 201
				raise "Mint post failed with response code: " + response.code.to_s + " Response: " + response
			end
			response
		}
	end
  
	def on_error(exception)
		#log error
		@logger.error("Mint Submission failure: " + exception.to_s + "\n" + exception.backtrace.join("\n"))
		#create error message from failed message body
		error_message = {}
		error_message['original_message'] = @body
		error_message['error_message'] = exception.to_s
		queue = TorqueBox.fetch('/queues/mint_submit_error')
		queue.publish(error_message)
	end

end

#------------ TO RUN UNIT IN ISOLATION UNCOMMENT BELOW ----------------------------
#require_relative '../../../../MigrateRegister/apps/Migrator/register_transformer.rb'
#rt = RegisterTransformer.new
#mec = MintEmitterConsumer.new
#pp JSON.parse(mec.process_message(rt.transform_register('BK506704')))