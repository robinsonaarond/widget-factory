# frozen_string_literal: true

class Tips::TipsComponent < ViewComponent::Base
  def initialize(library_mode: false)
    @library_mode = library_mode
  end

  def before_render
    @library_mode ||= params[:library_mode]
    if @library_mode
      @tip = "Utilizing online marketing platforms, such as MoxiPromote, can help you reach a wider audience and generate leads."
      @cta_label = "Learn more"
      @cta_url = ""
      @bg = "1"
    else
      tips_params = params["tips"]
      @tip = tips_params["description"]
      @cta_label = tips_params["cta_label"]
      @cta_url = tips_params["cta_url"]
      @bg = tips_params["bg"] || "1"
    end
    @widget = Widget.find_by(component: "tips")
  end
end
