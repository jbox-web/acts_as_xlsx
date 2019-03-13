class CreateTables < ActiveRecord::Migration[4.2]
  def up
    create_table :authors, force: true do |t|
      t.string :name
    end

    create_table :comments, force: true do |t|
      t.text    :content
      t.integer :post_id
      t.integer :author_id
      t.timestamps
    end

    create_table :posts, force: true do |t|
      t.string  :name
      t.string  :title
      t.text    :content
      t.integer :votes
      t.timestamps
    end
  end
end
