require 'mti/version'
require 'mti/railtie' if defined?(Rails::Railtie)

module MTI
  class TableNotInheritedError < StandardError; end
end
