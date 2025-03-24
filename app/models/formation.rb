class Formation < ApplicationRecord
  acts_as_paranoid

  belongs_to :team

  scope :from_year, ->(year) { where(year: year) }
end
