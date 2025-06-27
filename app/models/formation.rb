class Formation < ApplicationRecord
  acts_as_paranoid
  audited

  belongs_to :formation_report
  belongs_to :team
  belongs_to :volunteer
end
