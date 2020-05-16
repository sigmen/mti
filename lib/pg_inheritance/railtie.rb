require 'pg_inheritance/active_record/schema_statements'
require 'pg_inheritance/active_record/schema_dumper'

module PGInheritance
  class Railtie < Rails::Railtie
    initializer 'pg_inheritance' do
      ActiveSupport.on_load(:active_record) do
        adapter_klass = ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter

        adapter_klass.prepend(PGInheritance::ActiveRecord::SchemaStatements)

        ::ActiveRecord::SchemaDumper.prepend(PGInheritance::ActiveRecord::SchemaDumper)
      end
    end
  end
end
