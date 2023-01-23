class UserWidget < ApplicationRecord
  belongs_to :widget

  include RankedModel
  ranks :row_order, with_same: :user_uuid
end
