class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token,  :forget_token, :reset_token, :phone_token, :phone_temp
  has_secure_password

  before_save :downcase_email
  before_create :create_activation_digest

  has_many :sportgrounds, dependent: :destroy
  has_many :pitches ,through: :sportgrounds
  has_many :schedules, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :active_follows, class_name: "Follow",
           foreign_key: "follower_id",dependent: :destroy
  has_many :passive_follows, class_name: "Follow",
           foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /[A-Z][a-z]\d/i


  validates :name, presence:true, length: { maximum: Settings.user.name.max_length }
  validates :email, presence:true, length: { maximum: Settings.user.mail.max_length },
    format: { with: VALID_EMAIL_REGEX}, uniqueness: true
  validates :password, presence: true,
    length: {minimum: Settings.user.password.min_length,
      maximum: Settings.user.password.max_length},
        format: {with: VALID_PASSWORD_REGEX}, allow_nil: true
  validates :phone, presence:false, length: { maximum: Settings.user.phone.max_length }, uniqueness: false

  scope :latest, -> {order("created_at desc")}

  def remember
    self.remember_token = User.new_token
    self.remember_digest = User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false  unless digest
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attributes remember_digest: nil
  end

  def activate
    update_attributes activated: true, activated_at: Time.zone.now
  end

  def verify_phone
    update_attributes phone_confirmed: true, phone_confirm_at: Time.zone.now, phone: self.phone_temp
  end

  def send_activation_email
    UsersMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end

  def send_password_reset_email
    UsersMailer.password_reset(self).deliver_now
  end

  def create_phone_digest
    self.phone_token = User.new_phone_token
    self .phone_digest = User.digest phone_token
    self.phone_confirmed = false
  end

  def send_phone_verify_message_to phone_number
    self.phone_temp = phone_number
    return if phone_sent_at && !phone_confirm_expired?
    client = Twilio::REST::Client.new ENV["account_sid"], ENV["auth_token"]
    message = client.messages.create({
      from: ENV["phone_number"],
      to: phone_number,
      body: I18n.t("users.verify.message",phone_token: phone_token, expired_time: 15 )
      })
    update_attributes phone_sent_at: Time.zone.now
    message.sid
  end

  def was? obj
    self == obj
  end

  def follow other_user
    return unless other_user
    following << other_user
  end

  def unfollow other_user
    return unless  other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  def active_follow user_id
    self.active_follows.find_by(followed_id: user_id)
  end

  def phone_confirm_expired?
    phone_sent_at < 1.minutes.ago
  end

  def password_reset_expired?
    reset_sent_at < Settings.user.expired_time.hours.ago
  end

  private

  def downcase_email
    email.downcase!
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ?
        BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def new_phone_token
      SecureRandom.base64 Settings.phone.token.len
    end
  end
end
