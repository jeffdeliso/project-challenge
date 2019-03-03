# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  dog_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Like < ApplicationRecord
  validates :user_id, uniqueness: { scope: :dog_id }
  validate :not_owner

  belongs_to :user

  belongs_to :dog

  private

    def not_owner
      errors.add(:user, "can't be dog's owner") if self.user_id == self.dog.owner_id
    end

end
