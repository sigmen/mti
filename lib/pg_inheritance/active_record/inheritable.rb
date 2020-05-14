module PGInheritance
  module ActiveRecord
    module Inheritable
      def drop_inheritance(table_name, parent_name)
        unless inherited?(table_name, parent_name)
          raise PGInheritance::TableNotInheritedError, "#{table_name} not inherited from #{parent_name}"
        end

        execute(drop_inheritance_query(table_name, parent_name))
      end

      private

      def inherited?(table_name, parent_name)
        table_parents(table_name).any? { |x| x['relname'] == parent_name.to_s }
      end

      def table_parents(table_name)
        execute(select_parents_query(table_name))
      end

      def drop_inheritance_query(table_name, parent_name)
        "ALTER TABLE #{table_name} NO INHERIT #{parent_name};"
      end

      def select_parents_query(table_name)
        <<-SQL
          SELECT pg_class.relname
          FROM pg_catalog.pg_inherits
          INNER JOIN pg_catalog.pg_class ON (pg_inherits.inhparent = pg_class.oid)
          WHERE inhrelid = '#{table_name}'::regclass
        SQL
      end
    end
  end
end
