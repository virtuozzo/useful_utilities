class DeeperNestedCount < ActiveRecord::Base
  extend ::Utils::AR::Methods

  belongs_to :count
  belongs_to :nested_count
end