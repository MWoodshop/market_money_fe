class CreateMarkets < ActiveRecord::Migration[7.0]
  def change
    create_table :markets do |t|
      t.string :name
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
