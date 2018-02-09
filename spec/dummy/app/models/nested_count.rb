class NestedCount < ActiveRecord::Base
  extend ::UsefulUtilities::AR::Methods

  belongs_to :count

  validates :y, presence: true
end
