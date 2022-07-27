class User < ApplicationRecord
    has_one_attached :avatar
    has_many :greeted_me, class_name: 'Relationship', foreign_key: 'greeted_id'
    has_many :greeted, class_name: 'Relationship', foreign_key: 'user_id'
end
