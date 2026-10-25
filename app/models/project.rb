class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy
  
  validates :name, presence: true
  
  def progress_percentage
    return 0 if tasks.empty?
    (tasks.where(status: 'done').count.to_f / tasks.count * 100).round
  end
  
  def tasks_by_status
    {
      todo: tasks.where(status: 'todo').count,
      in_progress: tasks.where(status: 'in_progress').count,
      done: tasks.where(status: 'done').count
    }
  end
end