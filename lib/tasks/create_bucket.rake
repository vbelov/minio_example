desc 'Creates bucket'
task create_bucket: :environment do
  bucket = ActiveStorage::Blob.service.bucket
  bucket.create unless bucket.exists?
end
