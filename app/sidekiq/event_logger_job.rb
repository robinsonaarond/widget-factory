class EventLoggerJob
  include Sidekiq::Job

  def perform(event_type, component, event_data, agent_uuid, company_uuid, board_uuid, office_uuid)
    event_data[:component] = component
    event_data[:board_uuid] = board_uuid
    event_data[:office_uuid] = office_uuid

    @result = WmsSvcConsumer::Models::Event.log("nucleus_logging_event", "nucleus", {
    # TODO: Use widget events instead of nucleus events once they are added to the event service
    # @result = WmsSvcConsumer::Models::Event.log(event_type, "widget-factory", {
      agent_uuid: agent_uuid,
      company_uuid: company_uuid,
      event_data: event_data
    })
    raise StandardError, @result.errors.join(", ") if @result.errors.present?
  end
end
