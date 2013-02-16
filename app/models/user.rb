class User < ActiveRecord::Base
  has_secure_password
  
  attr_accessible :name, :password, :password_confirmation
  
  validates_uniqueness_of :name

  has_many :recipes
  has_many :comments
  has_many :friendships
  has_many :friends, through: :friendships

  has_many :evaluations, class_name: "RSEvaluation", as: :source
  has_reputation :votes, source: {reputation: :votes, of: :recipes}, aggregated_by: :sum

  def voted_for?(recipe)
  	evaluations.where(target_type: recipe.class, target_id: recipe.id)
  end
end
