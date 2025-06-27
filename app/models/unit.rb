class Unit < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true

  scope :by_name, -> { order(:name) }

  def self.ransackable_attributes(auth_object = nil)
    [ "name", "description", "created_at", "updated_at" ]
  end
end
