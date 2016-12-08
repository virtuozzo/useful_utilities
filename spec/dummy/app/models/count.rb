class Count < ActiveRecord::Base
  has_many :nested_counts

  validates :i, presence: true
end
