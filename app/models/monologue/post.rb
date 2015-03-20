class Monologue::Post < ActiveRecord::Base
  has_many :taggings
  has_many :tags, -> { order "id ASC" }, through: :taggings, dependent: :destroy
  before_validation :generate_url
  belongs_to :user

  scope :default,  -> {order("published_at DESC, monologue_posts.created_at DESC, monologue_posts.updated_at DESC") }
  scope :published, -> { default.where(published: true).where("published_at <= ?", DateTime.now) }

  default_scope{includes(:tags)}

  has_attached_file :landscape, :styles => { :large => "1066x708>", :thumb => "240x240>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :landscape, :content_type => /\Aimage\/.*\Z/
  validates_attachment_presence :landscape

  validates :user_id, presence: true
  validates :title, :content, :url, :published_at, presence: true
  validates :url, uniqueness: true
  validate :url_do_not_start_with_slash

  def tag_list= tags_attr
    self.tag!(tags_attr.split(","))
  end

  def tag_list
    self.tags.map { |tag| tag.name }.join(", ") if self.tags
  end

  def tag!(tags_attr)
    self.tags = tags_attr.map(&:strip).reject(&:blank?).map do |tag|
      Monologue::Tag.where(name: tag).first_or_create
    end
  end

  def full_url
    "/blogs/#{self.url}"
  end

  def published_in_future?
    self.published && self.published_at > DateTime.now
  end

  private

  def generate_url
    return unless self.url.blank?
    year = self.published_at.class == ActiveSupport::TimeWithZone ? self.published_at.year : DateTime.now.year
    self.url = "#{year}/#{self.title.parameterize}"
  end

  def url_do_not_start_with_slash
    errors.add(:url, I18n.t("activerecord.errors.models.monologue/post.attributes.url.start_with_slash")) if self.url.start_with?("/")
  end

end
