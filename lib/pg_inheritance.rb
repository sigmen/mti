require 'pg_inheritance/version'
require 'pg_inheritance/railtie' if defined?(Rails::Railtie)

module PGInheritance
  class TableNotInheritedError < StandardError; end
end
