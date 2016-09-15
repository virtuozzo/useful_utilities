class Count < ActiveRecord::Base
  attr_accessible :i

  has_many :nested_counts

  validates :i, presence: true
end