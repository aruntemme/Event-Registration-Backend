class ChangeDateFormatInMyTable < ActiveRecord::Migration[6.1]
  def change
    change_column :events, :configurefields, 'json USING CAST(configurefields AS json)'
  end
end
