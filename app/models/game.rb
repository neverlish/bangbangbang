class Game < ApplicationRecord
	has_many :mapia
	has_many :users, through: :mapia
end
