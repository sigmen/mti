module PGInheritance
  module ActiveRecord
    module Parentable
      def parent_table(table_name)
        result = execute(select_parents_query(table_name))

        return unless result.any?

        result.first['relname']
      end

      private

      def select_parents_query(table_name)
        <<-SQL
          SELECT pg_namespace.nspname, pg_class.relname
          FROM pg_catalog.pg_inherits
          INNER JOIN pg_catalog.pg_class ON (pg_inherits.inhparent = pg_class.oid)
          INNER JOIN pg_catalog.pg_namespace ON (pg_class.relnamespace = pg_namespace.oid)
          WHERE inhrelid = '#{table_name}'::regclass
          LIMIT 1
        SQL
      end
    end
  end
end
