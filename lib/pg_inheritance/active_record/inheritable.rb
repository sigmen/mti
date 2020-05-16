require 'pg_inheritance/active_record/parentable'

module PGInheritance
  module ActiveRecord
    module Inheritable
      include PGInheritance::ActiveRecord::Parentable

      TIMESTAMP_COLUMNS = %w[created_at updated_at].freeze

      def drop_inheritance(table_name, parent_name, **options)
        unless inherited?(table_name, parent_name)
          raise PGInheritance::TableNotInheritedError, "#{table_name} not inherited from #{parent_name}"
        end

        execute(drop_inheritance_query(table_name, parent_name)).tap do
          drop_inherited_columns(table_name, parent_name) if options[:with_columns]
        end
      end

      private

      def drop_inherited_columns(table_name, parent_name)
        cols_for_drop = columns_for_drop(table_name, parent_name)

        return if cols_for_drop.empty?

        execute(drop_columns_query(table_name, cols_for_drop))
      end

      def inherited?(table_name, parent_name)
        parent_table(table_name) == parent_name.to_s
      end

      def drop_inheritance_query(table_name, parent_name)
        "ALTER TABLE #{table_name} NO INHERIT #{parent_name};"
      end

      def drop_columns_query(table_name, columns)
        sql = "ALTER TABLE #{table_name}"

        columns_query = columns.map { |column| "DROP COLUMN IF EXISTS #{column}" }.join(', ')

        sql + " #{columns_query};"
      end

      def columns_for_drop(table_name, parent_name)
        child_cols = columns(table_name).map(&:name)
        parent_cols = columns(parent_name).map(&:name)

        (child_cols & parent_cols).tap do |cols|
          TIMESTAMP_COLUMNS.each { |col| cols.delete(col) }

          cols.delete(primary_key(table_name))
        end
      end
    end
  end
end
