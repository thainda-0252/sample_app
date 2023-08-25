class User < ApplicationRecord
  before_save :downcase_email
  validates :name,  presence: true, length: {maximum: Settings.users.max_name}
  validates :email, presence: true,
                    length: {maximum: Settings.users.max_email},
                    format: {with: Settings.users.VALID_EMAIL_REGEX},
                    uniqueness: true
  has_secure_password
  validates :password, presence: true,
                       length: {minimum: Settings.users.min_password},
                       allow_nil: true
  attr_accessor :remember_token

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # Returns a session token to prevent session hijacking.
  # We reuse the remember digest for convenience.
  def session_token
    remember_digest || remember
  end

  # Returns true if the given token matches the digest.
  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  private
  def downcase_email
    email.downcase!
  end
end
