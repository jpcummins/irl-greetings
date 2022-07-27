class Relationship < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :greeted, class_name: 'User'
end
