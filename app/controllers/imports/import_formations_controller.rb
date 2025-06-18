require 'csv'

class Imports::ImportFormationsController < ApplicationController
  def new
  end

  def create
    uploaded_file = params[:file]
    if uploaded_file.blank?
      redirect_to new_import_formation_path, alert: 'Nenhum arquivo foi selecionado.'
      return
    end

    report_name = params[:name]
    report_date = params[:date]
    if report_name.blank? || report_date.blank?
      redirect_to new_import_formation_path, alert: 'A formação deve ter um nome e uma data.'
      return
    end

    formation_report = FormationReport.new(name: report_name, date: report_date, active_volunteers_count: Volunteer.active.size, inactive_volunteers_count: Volunteer.inactive.size)

    if formation_report.save!
      CSV.foreach(uploaded_file.path, headers: true, col_sep: ',') do |row|
        answered_at = DateTime.strptime(row['Carimbo de data/hora'], '%d/%m/%Y %H:%M')
        email = row[1]
        volunteer = Volunteer.find_by(email: email)
        team = Team.find_by('LOWER(name) = ?', row['Equipe'].downcase)
        feedback = row['Espaço para feedback opcional sobre a formação:']

        next unless volunteer && team

        Formation.create!(
          answered_at: answered_at,
          feedback: feedback,
          team: team,
          volunteer: volunteer,
          formation_report: formation_report
        )
      end
    else
      redirect_to new_import_formation_path, alert: 'Erro ao salvar o relatório de formação.'
      return
    end

    redirect_to formations_path, notice: 'Arquivo CSV processado com sucesso!'
  rescue StandardError => e
    redirect_to imports_path, alert: "Erro ao processar o arquivo: #{e.message}"
  end
end
