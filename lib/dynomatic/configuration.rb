module Dynomatic
  class Configuration
    attr_accessor :adapter, :rules, :worker_names, :heroku_token, :heroku_app

    def sorted_rules
      @rules.sort_by { |rule| rule[:over] }
    end
  end
end
