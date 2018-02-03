module Dynomatic
  class HobbyScaler
    attr :scaler, :worker_processes

    def initialize(heroku_token, heroku_app, worker_processes)
      @scaler = Scaler.new(heroku_token, heroku_app)
      @worker_processes = worker_processes
    end

    def scale_to(dyno_count)
      start_processes = Array(worker_processes.first(dyno_count))
      stop_processes = Array(worker_processes[dyno_count..-1])

      start_processes.each do |process|
        scaler.start!(process)
      end

      stop_processes.each do |process|
        scaler.stop!(process)
      end
    end
  end
end
