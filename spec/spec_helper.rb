$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'smart_attr'
require 'active_record'

RSpec.configure do |config|
  config.after(:suite) do
    File.delete(File.expand_path('../../db/smart_attr_test', __FILE__))
  end
end

require 'mongoid'
mongoid_yml = File.expand_path('../../spec/fixtures/mongoid/mongoid.yml', __FILE__)
Mongoid.load!(mongoid_yml, :test)
