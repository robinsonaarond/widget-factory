# frozen_string_literal: true

require "concurrent"

class Rismedia::RismediaComponent < ApplicationComponent
  def before_render
    super
    return if @error.present?
    @expand_url = component_named_expanded_path(@widget.component, params[:session_id])
    @categories = ["news", "events", "reports"]
    @articles = {}
    get_articles
  end

  def get_articles
    promises = {}
    @categories.each do |category|
      promises[category] = Concurrent::Promise.execute do
        RestClient.get("https://www.rismedia.com/feed/StellarMLS-#{category}/")
      end
    end
    @categories.each do |category|
      promises[category].wait
      @articles[category] = JSON.parse(promises[category].value.body)
    end
  rescue => e
    @error = e
    @error_with_api = true
  end
end
