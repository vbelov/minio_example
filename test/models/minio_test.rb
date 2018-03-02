require 'test_helper'
require 'support/bucket_helper'

class MinioTest < ActiveSupport::TestCase
  include BucketHelper

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


  def key
    @key ||= FFaker::Lorem.word
  end
end
