class Formation < ApplicationRecord
  acts_as_paranoid

  belongs_to :team
end
