class Formation < ApplicationRecord
  acts_as_paranoid

  belongs_to :formation_report
  belongs_to :team
  belongs_to :volunteer
end
