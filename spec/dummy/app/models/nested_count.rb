class NestedCount < ActiveRecord::Base
  extend ::Utils::AR::Methods

  attr_accessible :y

  belongs_to :count

  validates :y, presence: true
end