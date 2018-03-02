module BucketHelper
  def minio
    ActiveStorage::Blob.service
  end

  def file_content
    @file_content ||= FFaker::Lorem.paragraph
  end

  def get_missing_bucket
    bucket = minio.bucket
    delete_bucket(bucket)
    bucket
  end

  def delete_bucket(bucket)
    if bucket.exists?
      keys = bucket.objects.map(&:key)
      bucket.delete_objects(
        delete: {
          objects: keys.map { |key| {key: key} }
        }
      )
      bucket.delete
    end
  end

  def empty_bucket
    get_missing_bucket.tap(&:create)
  end

  def within_bucket
    begin
      bucket = empty_bucket
      yield bucket
    ensure
      delete_bucket(bucket)
    end
  end
end
