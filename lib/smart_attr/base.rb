require 'active_support/all'
require 'smart_attr/config_hash'

module SmartAttr
  module Base

    extend ActiveSupport::Concern

    module ClassMethods

      def smart_attr *args
        column_name, options = args[0], args.extract_options!

        config = ConfigHash.new(options[:config])

        # result:
        # {
        #   one:    { value: 1, desc: 'one star' },
        #   two:    { value: 2, desc: 'two star' },
        #   three:  { value: 3, desc: 'three star' },
        #   four:   { value: 4, desc: 'four star' },
        #   five:   { value: 5, desc: 'five star' }
        # }
        define_singleton_method "#{column_name}_config".to_sym do |*_args|
          config
        end

        define_singleton_method "#{column_name}_config_hash".to_sym do |*_args|
          config.instance_variable_get :@config_hash
        end

        # result:
        # [
        #   ['one star', 1],
        #   ['two star', 2],
        #   ['three star', 3],
        #   ['four star', 4],
        #   ['five star', 5]
        # ]
        define_singleton_method "#{column_name}_array".to_sym do |*_args|
          _selector = self.send("#{column_name}_config").dup

          _selector.inject([]) do |_result, _pair|
            _key, _config = _pair

            _result << [_config[:value], _config[:desc]]
            _result
          end
        end

        # result:
        #
        # { value: 1, desc: 'one star' }
        #
        define_method "#{column_name}_config".to_sym do
          return {} unless self.class.respond_to?("#{column_name}_config".to_sym)

          result = self.class.send("#{column_name}_config").item(self.send(column_name.to_s))
          result || {}
        end

        define_method "#{column_name}_desc".to_sym do
          self.send("#{column_name}_config")[:desc]
        end

        define_method "#{column_name}_name".to_sym do
          self.send("#{column_name}_config")[:key]
        end

        all_instance_methods = self.private_instance_methods + self.instance_methods
        if all_instance_methods.include?(:write_attribute) && all_instance_methods.include?(:read_attribute)

          define_method "#{column_name}_name=".to_sym do |name|
            write_attribute(column_name, self.class.send("#{column_name}_config")[name].try(:[], :value))
          end

          config.keys.each do |_key|
            define_singleton_method "#{column_name}_#{_key}".to_sym do
              self.where("#{column_name}" => self.send("#{column_name}_config")[_key.to_sym].try(:[], :value))
            end

            define_method "#{column_name}_#{_key}!".to_sym do
              write_attribute(column_name, self.class.send("#{column_name}_config")[_key.to_sym].try(:[], :value))
            end

            define_method "#{column_name}_#{_key}?".to_sym do
              read_attribute(column_name) == self.class.send("#{column_name}_config")[_key.to_sym][:value]
            end
          end
        else
          attr_accessor column_name

          define_method "#{column_name}_name=".to_sym do |name|
            send("#{column_name}=", self.class.send("#{column_name}_config")[name].try(:[], :value))
          end

          config.keys.each do |_key|

            define_method "#{column_name}_#{_key}!".to_sym do
              send("#{column_name}=", self.class.send("#{column_name}_config")[_key.to_sym][:value])
            end

            define_method "#{column_name}_#{_key}?".to_sym do
              send(column_name) == self.class.send("#{column_name}_config")[_key.to_sym][:value]
            end
          end
        end

      end
    end
  end
end

# TODO
# Object.send :include, SmartAttr::Base
# ActiveRecord::Base.send :include, SmartAttr::Base if Module.constants.include? :ActiveRecord
# Mongoid::Document.send :include,  SmartAttr::Base if Module.constants.include? :Mongoid
