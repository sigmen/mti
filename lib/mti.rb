require 'mti/version'
require 'mti/railtie' if defined?(Rails::Railtie)

module MTI
  class UnsupportedError < StandardError; end
end
