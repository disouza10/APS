require "csv"

class Imports::ImportFormationsController < ApplicationController
  def new
  end

  def create
    uploaded_file = params[:file]
    if uploaded_file.blank?
      redirect_to new_import_formation_path, alert: "Nenhum arquivo foi selecionado."
      return
    end

    name = params[:name]
    if name.blank?
      redirect_to new_import_formation_path, alert: "A formação deve ter um nome."
      return
    end

    begin
      CSV.foreach(uploaded_file.path, headers: true, col_sep: ",") do |row|
        answered_at = DateTime.strptime(row["Carimbo de data/hora"], "%d/%m/%Y %H:%M")
        year = answered_at.year
        email = row[1]
        volunteer_name = row["Nome"]
        team = Team.find_by("LOWER(name) = ?", row["Equipe"].downcase)
        feedback = row["Espaço para feedback opcional sobre a formação:"]

        return if Formation.find_by("LOWER(name) = ? AND year = ?", name.downcase, year).present?

        formation = Formation.new(name: name, answered_at: answered_at, year: year, volunteer_email: email, volunteer_name: volunteer_name, team: team, feedback: feedback)
        formation.save!
      end
      redirect_to formations_path, notice: "Arquivo CSV processado com sucesso!"
    rescue => e
      redirect_to imports_path, alert: "Erro ao processar o arquivo: #{e.message}"
    end
  end
end
