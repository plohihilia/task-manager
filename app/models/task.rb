class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user, optional: true
  
  validates :title, presence: true
  validates :status, inclusion: { in: %w[todo in_progress done] }
  validates :priority, inclusion: { in: 0..2 }, allow_nil: true
  
  before_validation :set_default_status
  before_validation :set_default_priority
  
  PRIORITY_LABELS = { 0 => 'Низкий', 1 => 'Средний', 2 => 'Высокий' }.freeze
  PRIORITY_COLORS = { 0 => 'info', 1 => 'warning', 2 => 'danger' }.freeze
  
  scope :by_status, ->(status) { where(status: status) }
  scope :by_priority, ->(priority) { where(priority: priority) }
  scope :overdue, -> { where("deadline < ?", Date.today).where.not(status: 'done') }
  
  private
  
  def set_default_status
    self.status ||= 'todo'
  end
  
  def set_default_priority
    self.priority ||= 1
  end
end