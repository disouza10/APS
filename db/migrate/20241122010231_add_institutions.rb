class AddInstitutions < ActiveRecord::Migration[7.2]
  def change
    [ "ASVI 1",
      "ASVI 2",
      "Gira Sol 1",
      "Gira Sol 2",
      "Inpar",
      "Mangueira 1",
      "Mangueira 2",
      "Mundo Novo 1",
      "Mundo Novo 2",
      "Pequeno Dom",
      "Santa Ignez 1",
      "Santa Ignez 2",
      "Santa Ignez 3",
      "Santa Rita 1",
      "Santa Rita 2"
    ].each do |institution_name|
      Institution.create!(name: institution_name)
    end
  end
end
