class CreateSitesPokemons < ActiveRecord::Migration[8.0]
  def change
    create_table :sites_pokemons do |t|
      t.string :nickname
      t.string :kana
      t.string :registry_cellphone
      t.string :registry_postcode
      t.string :registry_fandi
      t.string :reg_password
      t.references :virtual_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
