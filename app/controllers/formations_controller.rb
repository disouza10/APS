class FormationsController < ApplicationController
  def index
  end

  def show
  end

  def show_by_year
    @report = Formation.report_by_year(params[:year])
    @year = params[:year]

    render :show
  end
end
