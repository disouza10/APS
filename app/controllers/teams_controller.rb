class TeamsController < ApplicationController
  before_action :set_team, only: %i[show edit destroy update]

  def index
    @teams = Team.all.page(params[:page])
  end

  def show
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to @team, notice: flash_created(@team)
    else
      render :new, error: flash_error
    end
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: flash_updated(@team)
    else
      render :edit, error: flash_error
    end
  end

  def destroy
    if @team.destroy
      redirect_to teams_path, notice: flash_removed(@team)
    else
      redirect_to teams_path, error: flash_error
    end
  end

  private

  def set_team
    @team = Team.find(params["id"])
  end

  def team_params
    params.require(:team).permit(
      :name,
      :status,
      :description,
      :institution_id
    )
  end
end
