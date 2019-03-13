class Area < ApplicationRecord
  validates :introduction, presence: true
  validates :zipcode, presence: true
end
