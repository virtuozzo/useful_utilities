class NestedCount < ActiveRecord::Base
  extend ::Utils::AR::Methods

  belongs_to :count

  validates :y, presence: true
end
