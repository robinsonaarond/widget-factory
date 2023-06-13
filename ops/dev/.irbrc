# Tab completion
require "irb/completion"
# Save irb sessions to history file
require "irb/ext/save-history"

IRB.conf[:SAVE_HISTORY] = 2000
IRB.conf[:HISTORY_FILE] = "/app/log/.irb-history"
