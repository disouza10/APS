require "csv"

class Imports::VolunteersController < ApplicationController
  def new
  end

  def create
    uploaded_file = params[:file]

    if uploaded_file.present?
      CSV.foreach(uploaded_file.path, headers: true, col_sep: ",") do |row|
        begin
          created_at = DateTime.strptime(row["Carimbo de data/hora"], "%d/%m/%Y %H:%M")
          email = row[1]
          full_name = row["Nome completo"]
          phone = row["Telefone de contato"]
          address = row["Endereço"]
          occupation = row["Profissão"]
          emergency_contact_name = row["Contato de emergência (telefone + nome + identificação)"]
          current_team = Team.find_by("LOWER(name) = ?", row["Equipe"].downcase)
          notes = row["Informações relevantes: Nesse campo, você pode detalhar alguma intolerância, alergia ou questão específica de saúde/alimentação. Se for o caso, sinta-se a vontade para compartilhar conosco. Obs: essa informação poderá ser compartilhada com o líder da sua equipe."]
          birth_date = row["Data de nascimento"].nil? ? nil : Date.parse(row["Data de nascimento"])
          coordination_notes = row["Observações da coordenação"]
          original_team = Team.find_by("LOWER(name) = ?", row["Equipe Original"]&.downcase)

          volunteer = Volunteer.new(
            full_name: full_name,
            email: email,
            birth_date: birth_date,
            phone: phone,
            address: address,
            occupation: occupation,
            emergency_contact_name: emergency_contact_name,
            current_team: current_team,
            notes: notes,
            coordination_notes: coordination_notes,
            original_team: original_team,
            created_at: created_at
          )
          volunteer.save!
        rescue => e
          redirect_to new_volunteer_path, alert: "Erro ao processar o arquivo: #{e.message}"
        end
      end
      redirect_to new_volunteer_path, notice: "Arquivo CSV processado com sucesso!"
    else
      redirect_to new_volunteer_path, alert: "Nenhum arquivo foi selecionado."
    end
  end
end