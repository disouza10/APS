class Volunteer < ApplicationRecord
  acts_as_paranoid
  audited

  belongs_to :current_team, class_name: 'Team', optional: true
  belongs_to :original_team, class_name: 'Team', optional: true

  enum status: { active: 'active', inactive: 'inactive' }, _default: 'active'

  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }

  scope :search, ->(query) {
    return current_scope if query.blank?

    where('full_name ILIKE ?', "%#{sanitize_sql_like(query)}%")
  }

  before_save :downcase_email

  def team
    current_team
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
