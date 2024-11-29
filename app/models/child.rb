class Child < ApplicationRecord
  self.table_name = "children"

  acts_as_paranoid

  belongs_to :team
  belongs_to :institution
end
