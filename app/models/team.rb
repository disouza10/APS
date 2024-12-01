class Team < ApplicationRecord
  acts_as_paranoid

  belongs_to :institution

  has_many :current_volunteers, class_name: "Volunteer", foreign_key: "current_team_id"
  has_many :original_volunteers, class_name: "Volunteer", foreign_key: "original_team_id"
  has_many :children, class_name: "Child"

  enum status: { active: "active", inactive: "inactive" }, _default: "active", _suffix: true
end
