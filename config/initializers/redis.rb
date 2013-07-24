config = YAML.load( File.open( Rails.root.join("config/redis.yml") ) )[Rails.env]
$redis = Redis.new(config)