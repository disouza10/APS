class FormationsController < ApplicationController
  def index
  end

  def show
  end

  def show_by_year
    @formation = FormationReport.where(year: params[:year]).first

    render :show
  end
end
