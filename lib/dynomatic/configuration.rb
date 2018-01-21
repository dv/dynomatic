module Dynomatic
  class Configuration
    attr_accessor :adapter, :rules, :heroku_key, :heroku_app

    def sorted_rules
      @rules.sort_by { |rule| rule[:over] }
    end
  end
end
