class User < ApplicationRecord
  has_secure_password

  # Generate new token
  def generate_auth_token
    self.auth_token = Digest::SHA512.hexdigest(SecureRandom.hex)
    self.updated_at = Time.current
    self.save!
    self.auth_token
  end

  # Invalidate auth toke
  def invalidate_auth_token
    self.update(auth_token: nil)
  end
end
