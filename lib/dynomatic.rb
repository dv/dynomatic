require "active_job"
require "dynomatic/version"

module Dynomatic
  extend ActiveSupport::Autoload

  autoload :Adapters
  autoload :Configuration
  autoload :Master
  autoload :Scaler
  autoload :HobbyScaler

  mattr_accessor(:configuration) { Configuration.new }

  def self.configure
    configuration.adapter ||= Dynomatic::Adapters.detect

    yield(configuration)

    Dynomatic::Master.new(configuration).install!
  end
end
