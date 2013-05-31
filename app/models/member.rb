class Member < ActiveRecord::Base
  has_many :participations
  has_many :gatherings, through: :participations
  has_many :created_gatherings, class_name: 'Gathering', foreign_key: 'owner_id'

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |member|
      member.provider = auth["provider"]
      member.uid = auth["uid"]
      member.name = auth["info"]["nickname"]
    end
  end
end