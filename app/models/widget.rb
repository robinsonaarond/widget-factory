class Widget < ApplicationRecord
  enum status: {ready: "ready", draft: "draft", deactivated: "deactivated"}

  scope :activated_widgets, -> {
    where(status: Widget.statuses[:ready], activation_date: ..Time.zone.now)
  }

  validates :name, presence: true

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
