require 'pg_inheritance/active_record/parentable'

module PGInheritance
  module ActiveRecord
    module Inheritable
      include PGInheritance::ActiveRecord::Parentable

      def drop_inheritance(table_name, parent_name)
        unless inherited?(table_name, parent_name)
          raise PGInheritance::TableNotInheritedError, "#{table_name} not inherited from #{parent_name}"
        end

        execute(drop_inheritance_query(table_name, parent_name))
      end

      private

      def inherited?(table_name, parent_name)
        parent_table(table_name) == parent_name.to_s
      end

      def drop_inheritance_query(table_name, parent_name)
        "ALTER TABLE #{table_name} NO INHERIT #{parent_name};"
      end
    end
  end
end
