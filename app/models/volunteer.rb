class Volunteer < ApplicationRecord
  acts_as_paranoid

  belongs_to :current_team, class_name: "Team", optional: true
  belongs_to :original_team, class_name: "Team", optional: true
  # belongs_to :user
end
