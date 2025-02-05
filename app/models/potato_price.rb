class PotatoPrice < ApplicationRecord
  validates :time, presence: true, uniqueness: true
  validates :value, presence: true, numericality: { greater_than: 0 }

  scope :for_date, ->(date) { where(time: date.beginning_of_day..date.end_of_day) }
end