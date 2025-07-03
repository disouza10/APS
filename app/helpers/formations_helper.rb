module FormationsHelper
  STATUSES = {
    'ok' => 'OK',
    'attention' => 'Atenção',
    'critical' => 'Crítico'
  }.freeze

  def translated_volunteer_status(status)
    STATUSES[status]
  end
end
