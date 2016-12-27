module SmartAttr
  class ConfigHash

    attr_reader :config_values_map

    def initialize(*args)
      @config_hash = args.extract_options!

      @config_values_map = {}

      @config_hash.each do |_key, _config|
        @config_values_map[_config[:value]] = _config.merge(key: _key)
      end
    end

    def item(value)
      @config_values_map[value]
    end

    def keys
      @config_hash.keys
    end

    def [](key)
      @config_hash[key]
    end

    # TODO
    # Add spec
    # def method_missing
    #   # delegate to Hash
    # end
  end
end
