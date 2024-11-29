class Institution < ApplicationRecord
  acts_as_paranoid

  has_many :children
  has_many :volunteers
  has_many :teams
end
