require 'mti/connection_adapter/postgresql/schema_statements'

module MTI
  class Railtie < Rails::Railtie
    initializer 'mti' do |_app|
      ActiveSupport.on_load(:active_record) do
        adapter_klass = ActiveRecord::ConnectionAdapters::PostgreSQLAdapter

        adapter_klass.prepend(ConnectionAdapter::PostgreSQL::SchemaStatements)
      end
    end
  end
end
