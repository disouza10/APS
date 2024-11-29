class Team < ApplicationRecord
  acts_as_paranoid

  belongs_to :institution

  has_many :volunteers
  has_many :children, class_name: "Child"

  enum status: { active: "active", inactive: "inactive" }, _default: "active", _suffix: true
end
