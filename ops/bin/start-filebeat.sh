
if [ "eks" = "${ORCHESTRATOR}" ]; then
  filebeat -c /app/filebeat.yml
fi

