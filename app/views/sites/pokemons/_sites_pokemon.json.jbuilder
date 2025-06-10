json.extract! sites_pokemon, :id, :nickname, :kana, :registry_cellphone, :registry_postcode, :registry_fandi, :reg_password, :virtual_user_id, :created_at, :updated_at
json.url sites_pokemon_url(sites_pokemon, format: :json)
