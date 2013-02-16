class Recipe < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) {controller && controller.current_user}

  attr_accessible :description, :image_url, :name

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_reputation :votes, source: :user, aggregated_by: :sum
end
