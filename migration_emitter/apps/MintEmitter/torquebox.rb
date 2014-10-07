TorqueBox.configure do
	queue '/queues/mint_submit' do
		durable false
		processor MintEmitterConsumer do
			concurrency 1
		end
	end
	
	queue '/queues/mint_submit_error' do
		durable false
	end
	
	queue '/queues/mint_submit_completed' do
		durable false
	end

	queue 'DLQ'
	queue 'ExpiryQueue'
end
