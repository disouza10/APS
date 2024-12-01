class AddInactiveAndSanitizedNameToTeams < ActiveRecord::Migration[7.2]
  def up
    add_column :teams, :sanitized_name, :string

    Team.all.each { |team| team.update(sanitized_name: team.name.parameterize(separator: '_')) }
  end

  def down
    remove_column :teams, :sanitized_name, :string
  end
end
