require "csv"

class Imports::FormationsController < ApplicationController
  def new
  end

  def create
    uploaded_file = params[:file]

    begin
      if uploaded_file.present?
        CSV.foreach(uploaded_file.path, headers: true, col_sep: ",") do |row|
          answered_at = DateTime.strptime(row["Carimbo de data/hora"], "%d/%m/%Y %H:%M")
          email = row[1]
          volunteer_name = row["Nome"]
          team = Team.find_by("LOWER(name) = ?", row["Equipe"].downcase)
          feedback = row["Espaço para feedback opcional sobre a formação:"]

          formation = Formation.new(name: params[:name], answered_at: answered_at, volunteer_email: email, volunteer_name: volunteer_name, team: team, feedback: feedback)
          formation.save!
        end
        redirect_to imports_path, notice: "Arquivo CSV processado com sucesso!"
      else
        redirect_to imports_path, alert: "Nenhum arquivo foi selecionado."
      end
    rescue => e
      redirect_to imports_path, alert: "Erro ao processar o arquivo: #{e.message}"
    end
  end
end
