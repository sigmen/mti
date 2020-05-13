require 'mti/active_record/schema_statements'

module MTI
  class Railtie < Rails::Railtie
    initializer 'mti' do
      ActiveSupport.on_load(:active_record) do
        adapter_klass = ::ActiveRecord::ConnectionAdapters::PostgreSQLAdapter

        adapter_klass.prepend(MTI::ActiveRecord::SchemaStatements)
      end
    end
  end
end
