# == Schema Information
#
# Table name: dogs
#
#  id            :integer          not null, primary key
#  name          :string
#  birthday      :datetime
#  adoption_date :datetime
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_id      :integer
#

class Dog < ApplicationRecord

  has_many_attached :images

  belongs_to :owner,
    class_name: :User

  has_many :likes

end
