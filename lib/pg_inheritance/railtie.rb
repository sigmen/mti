require 'pg_inheritance/active_record/schema_statements'

module PGInheritance
  class Railtie < Rails::Railtie
    initializer 'pg_inheritance' do
      ActiveSupport.on_load(:active_record) do
        adapter_klass = ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter

        adapter_klass.prepend(PGInheritance::ActiveRecord::SchemaStatements)
      end
    end
  end
end
