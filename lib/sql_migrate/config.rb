module SqlMigrate
  class Config
    VALID_OPTIONS = [
      :host,
      :port,
      :user,
      :password,
    ].freeze

    attr_accessor *VALID_OPTIONS

    def initialize
      reset
    end

    def merge(params)
      params.each do |key, value|
        self.send("#{key}=", value)
      end
      self
    end

    def reset
      self.host = "localhost"
      self.port = 3306
      self.user = "root"
    end
  end
end
