class Volunteer < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :team
end
