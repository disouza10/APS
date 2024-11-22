class Institution < ApplicationRecord
  acts_as_paranoid

  has_many :teams
end
