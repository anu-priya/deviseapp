path = File.join(Rails.root, "config/s3.yml")
#~ S3_CONFIG = YAML.load(File.read(path))[Rails.env] || {'bucket' => '', 'access_key_id' => '', 'secret_access_key' => ''}


if File.exists?(path)
        YAML.load_file(path)[Rails.env].each do |key, value|
          ENV[key.to_s] = value
  end # end YAML.load_file
end