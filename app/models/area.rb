class Area < ApplicationRecord
  validates :zipcode, presence: true
  validates :introduction, presence: true
end
