puts "Loaded!"

module Dynomatic
  module Adapters
    class DelayedJob < Adapter
      def job_count
        Delayed::Job.where("run_at <= NOW()").count
      end
    end
  end
end
