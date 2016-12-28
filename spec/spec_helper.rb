$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'smart_attr'
require 'active_record'

RSpec.configure do |config|
  config.after(:suite) do
    File.delete(File.expand_path('../../db/smart_attr_test', __FILE__))
  end
end
