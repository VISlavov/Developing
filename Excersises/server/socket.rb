class CustomSocket

	attr_accessor :status, :socket

	@@SOCKET_STATUSES = {
		:ready => 'ready',
		:processed => 'processed',
	}

	def initialize socket, status
		@socket = socket
		@status = status
	end

	def self.SOCKET_STATUSES
		@@SOCKET_STATUSES
	end
	
end
