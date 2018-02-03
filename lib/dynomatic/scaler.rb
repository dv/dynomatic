require "platform-api"

module Dynomatic
  class Scaler
    attr :heroku_token, :heroku_app

    def initialize(heroku_token, heroku_app)
      @heroku_token = heroku_token
      @heroku_app = heroku_app
    end

    def scale_to(dyno_count, type: "worker")
      Rails.logger.info "Scaling #{type} to #{dyno_count}"

      client.formation.update(heroku_app, type, {quantity: dyno_count})
    end

    def start!(type)
      scale_to(1, type: type)
    end

    def stop!(type)
      scale_to(0, type: type)
    end

    private

    def client
      @client = ::PlatformAPI.connect_oauth(heroku_token)
    end
  end
end
