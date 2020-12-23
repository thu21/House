class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :image, ImageUploader

  has_many :house
  has_many :comment
  has_many :care
  has_one :request_host
  has_one :notification

  validates_processing_of :image
  validate :image_size_validation

  def role_enum
    ["admin", "host", "user"]
  end

  before_update do
    if (self.role == "host")
      Notification.create(user_id: 1, title: "Admin đã phê duyệt bạn trở thành Host", status: "none", user_recived_id: self.id)
    else
      Notification.create(user_id: 1, title: "Admin đã từ chối yêu cầu thành Host của bạn", status: "none", user_recived_id: self.id)
    end
  end

  private

  def image_size_validation
    errors[:image] << "should be less than 2.5MB" if image.size > 2.5.megabytes
  end
end
