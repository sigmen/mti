module PGInheritance
  module ActiveRecord
    module SchemaDumper
      def table(child_table, stream)
        return if dumped_tables.include?(child_table)

        new_stream = StringIO.new

        super(child_table, new_stream)

        string = new_stream.string
        parent_table = @connection.parent_table(child_table)

        if parent_table
          string = handle_parent(parent_table, child_table, stream, string)
        end

        dumped_tables << child_table

        stream.tap { |s| s.write(string) }
      end

      private

      def dumped_tables
        @dumped_tables ||= []
      end

      def handle_parent(parent_table, child_table, stream, string)
        table(parent_table, stream)

        string = inject_inherits_for_create_table(string, child_table, parent_table)
        string = remove_parent_table_columns(string, @connection.columns(parent_table))

        parent_indexes = @connection.indexes(parent_table).map { |index| [index.name, index] }.to_h
        child_indexes = @connection.indexes(child_table).map { |index| [index.name, index] }.to_h

        intersected_index_names = parent_indexes.keys & child_indexes.keys

        remove_parent_table_indexes(string, parent_indexes.slice(*intersected_index_names))
      end

      def inject_inherits_for_create_table(string, table, parent_table)
        tbl_start = "create_table #{remove_prefix_and_suffix(table).inspect}"
        tbl_end = ' do |t|'
        tbl_inherit = ", inherits: '#{parent_table}'"

        string.gsub!(/#{Regexp.escape(tbl_start)}.*#{Regexp.escape(tbl_end)}/, tbl_start + tbl_inherit + tbl_end)
      end

      def remove_parent_table_columns(string, columns)
        columns.each do |col|
          string.gsub!(/\s+t\.\w+\s+("|')#{col.name}("|').*/, '')
        end

        string
      end

      def remove_parent_table_indexes(string, indexes)
        indexes.each do |index|
          string.gsub!(/\s+t\.index.*("|')#{index.name}("|').*/, '')
        end

        string
      end

      def remove_prefix_and_suffix(table)
        table.gsub(/^(#{::ActiveRecord::Base.table_name_prefix})(.+)(#{::ActiveRecord::Base.table_name_suffix})$/, '\\2')
      end
    end
  end
end
