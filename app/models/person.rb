class Person < ApplicationRecord
  has_many :simulation_results, dependent: :destroy
  
  validates :name, presence: true
  validates :age, presence: true, numericality: { greater_than: 0 }
  validates :classification, inclusion: { in: %w[kid teenager adult] }, allow_blank: true
  
  before_validation :set_classification_by_age
  
  serialize :taste_preferences, coder: JSON
  
  scope :kids, -> { where(classification: 'kid') }
  scope :teenagers, -> { where(classification: 'teenager') }
  scope :adults, -> { where(classification: 'adult') }
  
  def taste_preference_list
    taste_preferences || []
  end
  
  def likes_taste?(taste)
    taste_preference_list.include?(taste.to_s)
  end
  
  private
  
  def set_classification_by_age
    self.classification = case age
                         when 0..12
                           'kid'
                         when 13..19
                           'teenager'
                         else
                           'adult'
                         end
  end
end
