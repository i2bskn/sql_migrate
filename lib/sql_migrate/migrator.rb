module SqlMigrate
  class Migrator
    extend Forwardable

    attr_accessor :config
    def_delegator :config, :logger

    VERSION_TABLE_NAME = "migrate_versions".freeze

    def initialize(config = nil)
      @config = config || Config.new
    end

    def migrate
      create_migrate_versions_if_not_exist
      versions = applied_versions
      migration_files.each do |migration|
        version_name = File.basename(migration)
        next if versions.include?(version_name)
        unless config.applied
          logger.info("apply migration #{version_name}")
          queries_from_migration_file(migration).each { |sql| execute(sql) }
        end
        sql = "insert into #{VERSION_TABLE_NAME} (`version`) values (\"#{version_name}\")"
        execute(sql)
      end
    end

    def create_migrate_versions_if_not_exist
      unless table_names.include?(VERSION_TABLE_NAME)
        sql = <<-EOS
          create table `#{VERSION_TABLE_NAME}` (
            `version` varchar(128),
            PRIMARY KEY (`version`)
          ) ENGINE=InnoDB DEFAULT CHARSET=utf8
        EOS
        logger.info("create #{VERSION_TABLE_NAME}")
        connection.query(sql)
      end
    end

    def table_names
      connection.query("show tables", as: :array).to_a.flatten
    end

    def applied_versions
      connection.query("select * from #{VERSION_TABLE_NAME}", as: :array).to_a.flatten
    end

    def migration_files
      config.migration_paths.map { |path|
        Dir.glob(File.join(File.expand_path(path), "*"))
      }.flatten.sort
    end

    private

      def execute(sql)
        logger.info("execute sql:\n#{sql}") if config.verbose
        connection.query(sql) unless dryrun?
      end

      def queries_from_migration_file(path)
        migration_text = File.read(path)
        migration_text.split(";").map(&:strip).reject(&:empty?)
      end

      def dryrun?
        !!config.dryrun
      end

      def connection
        @connection ||= Mysql2::Client.new(**db_options)
      end

      def db_options
        options = {
          host: config.host,
          port: config.port,
          database: config.database,
          username: config.user,
        }
        options[:password] = config.password if config.password
        options
      end
  end
end
