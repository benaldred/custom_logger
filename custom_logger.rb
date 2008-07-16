require 'colored'


# I have added a new level of message caledd trace.

module ActiveSupport
  # Extend the BufferedLogger and add a trace level and methods
  class BufferedLogger
    module Severity
          DEBUG   = 0
          INFO    = 1
          WARN    = 2
          ERROR   = 3
          FATAL   = 4
          UNKNOWN = 5
          TRACE   = 6
    end
    
    def trace(message = nil, progname = nil, &block)
      add(TRACE, message, progname, &block)
    end

    def trace?
      TRACE >= @level
    end
    
    def trace_message(message)
      "TRACE: #{message}\n".yellow
    end
      
    # override add method to add colouring on trace. I uses the colored gem
    #   
    def add(severity, message = nil, progname = nil, &block)
      return if @level > severity
     # message = (message || (block && block.call) || progname).to_s
     message = (message || (block && block.call) || progname).to_s
      # If a newline is necessary then create a new message ending with a newline.
      # Ensures that the original message is not mutated.
      message = "#{message}\n" unless message[-1] == ?\n
      # add some colours to debug level
      message = trace_message(message) if severity == 6
      @buffer << message
      auto_flush
      message
    end
  end
end