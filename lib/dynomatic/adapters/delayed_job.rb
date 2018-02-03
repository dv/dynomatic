module Dynomatic
  module Adapters
    class DelayedJob
      def job_count
        Delayed::Job.where("run_at <= NOW()").count
      end
    end
  end
end
