module Dynomatic
  module Adapters
    extend ActiveSupport::Autoload

    autoload :DelayedJob

    module_function

    def detect
      case
      when defined? ::Delayed::Job
        Dynomatic::Adapters::DelayedJob
      else
        nil
      end
    end
  end
end
