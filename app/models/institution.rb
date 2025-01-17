class Institution < ApplicationRecord
  acts_as_paranoid

  has_many :children
  # has_many :volunteers
  has_many :teams

  def volunteers_count
    self.teams.map { |team| team.volunteers.count }.sum
  end
end
