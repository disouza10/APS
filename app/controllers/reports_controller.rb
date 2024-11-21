require "csv"

class ReportsController < ApplicationController
  def index
  end

  def import_report
    uploaded_file = params[:file]

    begin
      if uploaded_file.present?
        CSV.foreach(uploaded_file.path, headers: true, col_sep: ";") do |row|
          answered_at = DateTime.strptime(row["﻿Carimbo de data/hora"], "%d/%m/%Y %H:%M")
          email = row[1]
          name = row["Nome"]
          team = row["Equipe"]
          feedback = row["Espaço para feedback opcional sobre a formação:"]

          formation = Formation.new(answered_at: answered_at, email: email, name: name, team: team, feedback: feedback)
          formation.save!
        end
        redirect_to reports_path, notice: "Arquivo CSV processado com sucesso!"
      else
        redirect_to reports_path, alert: "Nenhum arquivo foi selecionado."
      end
    rescue => e
      redirect_to new_upload_path, alert: "Erro ao processar o arquivo: #{e.message}"
    end
  end
end
