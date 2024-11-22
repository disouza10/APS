class Team < ApplicationRecord
  acts_as_paranoid

  belongs_to :institution

  has_many :volunteers, class_name: "User", foreign_key: "volunteers_id"
  has_many :children, class_name: "Child", foreign_key: "children_id"

  enum status: { active: "active", inactive: "inactive" }, _default: "active", _suffix: true
end
