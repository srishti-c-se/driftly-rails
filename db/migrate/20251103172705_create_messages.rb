class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :threadable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.text :body
      t.datetime :read_at

      t.timestamps
    end
  end
end
