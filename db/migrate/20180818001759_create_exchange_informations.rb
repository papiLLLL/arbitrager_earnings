class CreateExchangeInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :exchange_informations do |t|
      t.text :created_on
      t.text :name
      t.integer :jpy_balance
      t.float :btc_balance
      t.integer :btc_price
      t.integer :btc_to_jpy_balance

      t.timestamps
    end
  end
end
