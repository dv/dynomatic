module Dynomatic
  class Master
    attr_accessor :current_dyno_count, :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def install!
      this = self

      ActiveJob::Base.before_perform do
        this.adjust_dynos!
      end
    end

    # Main method
    def adjust_dynos!
      job_count = configuration.adapter.job_count
      new_dyno_count = dyno_count_for_job_count(job_count)

      if current_dyno_count != new_dyno_count
        set_dyno_count!(new_dyno_count)
      end
    end

    private

    def dyno_count_for_job_count(job_count)
      rule = configuration.sorted_rules.reverse.find { |rule| rule[:at_least] <= job_count }

      rule[:dynos]
    end

    def set_dyno_count!(new_dyno_count)
      old_dyno_count = current_dyno_count
      self.current_dyno_count = new_dyno_count

      scaler.scale_to(new_dyno_count)
    rescue
      # If something went wrong, reset to old value
      self.current_dyno_count = old_dyno_count
      raise
    end

    def scaler
      @scaler ||= Scaler.new(configuration.heroku_key, configuration.heroku_app)
    end
  end
end
