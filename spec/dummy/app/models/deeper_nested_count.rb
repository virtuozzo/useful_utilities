class DeeperNestedCount < ActiveRecord::Base
  extend ::UsefulUtilities::AR::Methods

  belongs_to :count
  belongs_to :nested_count
end
