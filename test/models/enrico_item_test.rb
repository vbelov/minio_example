require 'test_helper'
require 'support/bucket_helper'

class EnricoItemTest < ActiveSupport::TestCase
  include BucketHelper

  test "downloads previously uploaded file successfully" do
    within_bucket do
      uf = EnricoItem.create!(content: uploaded_file)
      downloaded_content = uf.content_blob.download
      assert downloaded_content == file_content
    end
  end


  def uploaded_file
    @uploaded_file ||=
      begin
        f = StringIO.new(file_content)
        def f.open; self; end

        Rack::Test::UploadedFile.new(
          f,
          content_type,
          original_filename: 'filename'
        )
      end
  end

  def content_type
    Mime::LOOKUP.keys.sample
  end
end
