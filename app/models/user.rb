class User < ActiveRecord::Base

  attr_reader :password

  validates :email, :session_token, :password_digest, uniqueness: true, presence: true
  validates :password, length: { minimum: 6, allow_nil: true}
  after_initialize :ensure_session_token

  def ensure_session_token
    self.session_token ||= generate_session_token
  end

  def generate_session_token
    SecureRandom::urlsafe_base64
  end

  def reset_session_token!
    self.session_token = generate_session_token
    self.save!
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password).is_password?
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)

    return unless user

    user.password_digest.is_password?(password) ? user : nil
  end

  def password_digest
    BCrypt::Password.new(super)
  end


end
