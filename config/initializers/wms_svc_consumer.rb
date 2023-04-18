require "yaml"
require "wms_svc_consumer/wms_record"

WmsSvcConsumer::Base.site = "#{Rails.application.config.base_service}/service/v1/profile"
WmsSvcConsumer::Models::Event.site = "#{Rails.application.config.base_service}/service/event/v1"
WmsSvcConsumer::Models::Message.site = "#{Rails.application.config.base_service}/service/v1/message"
