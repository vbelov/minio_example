class CreateEnricoItems < ActiveRecord::Migration[5.2]
  def change
    create_table :enrico_items do |t|

      t.timestamps
    end
  end
end
