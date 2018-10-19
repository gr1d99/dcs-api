class Blacklist < ApplicationRecord
  validates :jti, presence: true, uniqueness: true

  def self.jti_exists?(jti)
    where(jti: jti).exists?
  end
end
