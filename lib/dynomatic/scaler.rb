require "platform-api"

module Dynomatic
  class Scaler
    attr :heroku_token, :heroku_app

    def initialize(heroku_token, heroku_app)
      @heroku_token = heroku_token
      @heroku_app = heroku_app
    end

    def scale_to(dyno_count)
      client.formation.update(heroku_app, 'worker', {quantity: dyno_count})
    end

    private

    def client
      @client = ::PlatformAPI.connect_oauth(heroku_token)
    end
  end
end
