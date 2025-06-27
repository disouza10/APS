class Child < ApplicationRecord
  self.table_name = 'children'

  acts_as_paranoid
  audited

  belongs_to :team
  belongs_to :institution
end
