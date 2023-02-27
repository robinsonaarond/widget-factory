class Widget < ApplicationRecord
  enum status: {ready: "ready", draft: "draft", deactivated: "deactivated"}

  has_one_attached :logo
  attribute :remove_logo, :boolean
  after_save :purge_logo, if: :remove_logo

  scope :activated_widgets, -> {
    where(status: Widget.statuses[:ready], activation_date: ..Time.zone.now)
      .or(where(status: Widget.statuses[:ready], activation_date: nil))
  }

  validates :name, presence: true

  def as_json(options = {})
    options[:methods] = [:activated, :logo_url]
    super
  end

  def activated
    status == Widget.statuses[:ready] && (activation_date.blank? || activation_date <= Time.zone.now)
  end

  def logo_url
    return unless logo.attached?
    Rails.application.routes.url_helpers.rails_representation_url(logo, only_path: true)
  end

  def restore!
    self.status = Widget.statuses[:draft]
    save
  end

  def activate!
    self.status = Widget.statuses[:ready]
    save
  end

  def deactivate!
    self.status = Widget.statuses[:deactivated]
    self.activation_date = nil
    save
  end

  private

  def purge_logo
    logo.purge_later
  end
end
