class CreateSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :searches do |t|
      t.string :query_parameters, unique: true
      t.integer :times_searched, default: 0

      t.index :query_parameters

      t.timestamps
    end
  end
end
