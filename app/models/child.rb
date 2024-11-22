class Child < ApplicationRecord
  acts_as_paranoid

  belongs_to :team, foreign_key: "children_id"
  belongs_to :institution
end
