module Dynomatic
  module Adapters
    extend ActiveSupport::Autoload

    autoload :DelayedJob

    module_function

    def detect
      case
      when defined? ::Delayed::Job
        Dynomatic::Adapters::DelayedJob.new
      else
        nil
      end
    end
  end
end
