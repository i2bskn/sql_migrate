module SqlMigrate
  class Migrator
    attr_accessor :config

    def initialize(config = nil)
      @config = config || Config.new
    end

    def migrate
    end
  end
end
