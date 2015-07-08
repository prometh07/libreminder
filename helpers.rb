require 'libnotify'

module Helper
  DUE_DATE = 7
  NOTIFY_TIMEOUT = 30
  LOG_FILE = 'log'
  LOGGER = Logger.new(LOG_FILE)

  def self.show_notification library_name, message, timeout
    Libnotify.show summary: library_name,
                   body: message,
                   timeout: timeout
  end
end
