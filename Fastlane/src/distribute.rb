fastlane_require './src/env.rb'

platform :ios do

  desc "uploads files to s3"
  lane :upload_files_to_s3 do |options|
    if ENV['FA_DISTRIBUTE_OFF']
      UI.important ":upload_files_to_s3 canceled with FA_DISTRIBUTE_OFF"
      next []
    end

    s3_profile = options[:profile]
    s3_region = options[:region]
    s3_bucket_name = options[:bucket]
    s3_path = options[:s3_path]
    files = options[:files]

    Aws.config.update({ region: s3_region })
    s3_client = Aws::S3::Client.new
    bucket = Aws::S3::Bucket.new(s3_bucket_name, client: s3_client)
    s3_uploaded_urls = []
    files.each do |file|
             file_basename = File.basename(file)
             file_data = File.open(file, 'rb')
             file_name = s3_path + '/' + file_basename

             details = {
               acl: "public-read",
               key: file_name,
               body: file_data,
               content_type: MIME::Types.type_for(File.extname(file_name)).first.to_s
             }
             obj = bucket.put_object(details)

             # Setting action and environment variables
             # When you enable versioning on a S3 bucket,
              # writing to an object will create an object version
              # instead of replacing the existing object.
              # http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/S3/ObjectVersion.html
              if obj.kind_of? Aws::S3::ObjectVersion
                obj = obj.object
              end
              uploaded_url = obj.public_url.to_s
              s3_uploaded_urls << uploaded_url
              UI.success("Uploaded file at #{uploaded_url}")
    end
    s3_uploaded_urls
  end
end
