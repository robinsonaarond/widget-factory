class Widget < ApplicationRecord
  enum status: {ready: "ready", draft: "draft", deactivated: "deactivated"}

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
    "/assets/#{component}/logo.png"
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
end
