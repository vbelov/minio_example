require 'test_helper'

class MinioTest < ActiveSupport::TestCase
  test "creates bucket successfully" do
    bucket = get_missing_bucket.tap(&:create)
    assert bucket.exists?
  end

  test 'uploads file successfully' do
    within_bucket do
      minio.upload(key, file_content)
      assert minio.exist?(key)
    end
  end

  test 'downloads file successfully' do
    within_bucket do
      minio.upload(key, file_content)
      downloaded_content = minio.download(key)
      assert downloaded_content == file_content
    end
  end


  def minio
    ActiveStorage::Blob.service
  end

  def key
    @key ||= FFaker::Lorem.word
  end

  def file_content
    @file_content ||= FFaker::Lorem.paragraph
  end

  def get_missing_bucket
    bucket = ActiveStorage::Blob.service.bucket
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
