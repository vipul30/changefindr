Paperclip::Attachment.default_options[:url] = ENV['AWS_URL']
Paperclip::Attachment.default_options[:path] = ENV['AWS_PATH']
Paperclip::Attachment.default_options[:s3_host_name] = ENV['AWS_S3_HOST_NAME']
Paperclip::Attachment.default_options[:region] = ENV['AWS_REGION']
Paperclip::Attachment.default_options[:bucket] = ENV['S3_BUCKET_NAME']
Paperclip::Attachment.default_options[:access_key_id] = ENV['AWS_ACCESS_KEY_ID']
Paperclip::Attachment.default_options[:secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY']
Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_protocol] = 'http'
Paperclip::Attachment.default_options[:s3_credentials] =
  { :bucket => ENV['AWS_BUCKET'],
    :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'] }
    