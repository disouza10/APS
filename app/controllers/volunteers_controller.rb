class VolunteersController < ApplicationController
  before_action :set_volunteer, only: %i[show edit destroy update]

  def index
    @volunteers = Volunteer.all
  end

  def show
  end

  def new
    @volunteer = Volunteer.new
  end

  def create
    @volunteer = Volunteer.new(volunteer_params)

    if @volunteer.save
      redirect_to @volunteer
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @volunteer.update(volunteer_params)
      redirect_to @volunteer
    else
      render :edit
    end
  end

  def destroy
    @volunteer.destroy
    redirect_to volunteers_path
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
