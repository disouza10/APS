class VolunteersController < ApplicationController
  before_action :set_volunteer, only: %i[show edit destroy update]

  def index
    scope = Volunteer.all.order(:full_name)
    scope = scope.search(params[:query])

    @volunteers = scope.page(params[:page])
  end

  def show
  end

  def new
    @volunteer = Volunteer.new
  end

  def create
    @volunteer = Volunteer.new(volunteer_params)

    if @volunteer.save
      redirect_to @volunteer, notice: flash_created(@volunteer)
    else
      render :new, error: flash_error
    end
  end

  def edit
  end

  def update
    if @volunteer.update(volunteer_params)
      redirect_to @volunteer, notice: flash_updated(@volunteer)
    else
      render :edit, error: flash_error
    end
  end

  def destroy
    if @volunteer.destroy
      redirect_to volunteers_path, notice: flash_removed(@volunteer)
    else
      redirect_to volunteers_path, error: flash_error
    end
  end

  private

  def set_volunteer
    @volunteer = Volunteer.find(params["id"])
  end

  def volunteer_params
    params.require(:volunteer).permit(
      :full_name,
      :birth_date,
      :email,
      :secondary_email,
      :phone,
      :occupation,
      :emergency_contact_name,
      :emergency_contact_phone,
      :address,
      :notes,
      :coordination_notes,
      :current_team_id,
      :original_team_id
    )
  end
end
