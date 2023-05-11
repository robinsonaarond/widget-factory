# frozen_string_literal: true

class Tips::TipsComponent < ApplicationComponent
  def before_render
    super
    return if @error.present?
    demo_params = {
      "description" => "Utilizing online marketing platforms, such as MoxiPromote, can help you reach a wider audience and generate leads.",
      "cta_label" => "Learn more",
      "cta_url" => "",
      "bg" => "1"
    }
    tips_params = params["tips"] || demo_params
    @id = tips_params["id"]
    @tip = tips_params["description"]
    @cta_label = tips_params["cta_label"]
    @cta_url = tips_params["cta_url"]
    @bg = tips_params["bg"] || "1"
  end
end
