require 'csv'

class Imports::ImportVolunteersController < ApplicationController
  def new
  end

  def create
    uploaded_file = params[:file]

    if uploaded_file.present?
      CSV.foreach(uploaded_file.path, headers: true, col_sep: ',') do |row|
        begin
          created_at = DateTime.strptime(row.first[1], '%d/%m/%Y %H:%M')
          email = row[1]
          full_name = row['Nome completo']
          phone = row['Telefone de contato']
          address = row['Endereço']
          occupation = row['Profissão']
          emergency_contact_name = row['Contato de emergência (telefone + nome + identificação)']
          current_team = Team.find_by('LOWER(name) = ?', row['Equipe'].downcase)
          status = current_team.nil? ? 'inactive' : 'active'
          notes = row['Informações relevantes: Nesse campo, você pode detalhar alguma intolerância, alergia ou questão específica de saúde/alimentação. Se for o caso, sinta-se a vontade para compartilhar conosco. Obs: essa informação poderá ser compartilhada com o líder da sua equipe.']
          birth_date = row['Data de nascimento'].nil? ? nil : Date.parse(row['Data de nascimento'])
          coordination_notes = row['Observações da coordenação']
          original_team = Team.find_by('LOWER(name) = ?', row['Equipe Original']&.downcase)

          volunteer = Volunteer.find_by(email: email)
          volunteer = Volunteer.where("REGEXP_REPLACE(phone, '[^0-9]', '') = ?", phone.gsub(/\D/, '')).first_or_initialize

          volunteer.update!(
            email: email,
            full_name: full_name,
            birth_date: birth_date,
            phone: phone,
            address: address,
            occupation: occupation,
            emergency_contact_name: emergency_contact_name,
            current_team: current_team,
            notes: notes,
            coordination_notes: coordination_notes,
            original_team: original_team,
            status: status,
            created_at: created_at
          )
        rescue => e
          redirect_to import_volunteers_path, alert: "Erro ao processar o arquivo: #{e.message}"
          return
        end
      end
      redirect_to volunteers_path, notice: 'Arquivo CSV processado com sucesso!'
    else
      redirect_to import_volunteers_path, alert: 'Nenhum arquivo foi selecionado.'
    end
  end
end
