module MTI
  module ConnectionAdapter
    module PostgreSQL
      module SchemaStatements
        def create_table(table_name, options = {})
          inherited_table = options.delete(:inherited_from)

          prepare_options(inherited_table, options)

          table_name = prepare_table_name(table_name, options)

          super(table_name, options)
        end

        private

        def prepare_options(inherited_table, options)
          remove_pk_option(options)
          add_inheritance_query(inherited_table, options)
        end

        def remove_pk_option(options)
          return unless options[:inherited_from]

          options[:id] = false
          options.delete(:primary_key)
        end

        def add_inheritance_query(inherited_table, options)
          return unless inherited_table

          options[:options] = build_inherits_option(inherited_table)
        end

        def prepare_table_name(table_name, options)
          schema = options.delete(:schema)

          return table_name unless schema

          "#{schema}.#{table_name}"
        end

        def build_inherits_option(inherited_table)
          "INHERITS (#{inherited_table})"
        end
      end
    end
  end
end
