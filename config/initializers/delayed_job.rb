# file_handle = File.open("log/#{Rails.env}_delayed_jobs.log", (File::WRONLY | File::APPEND | File::CREAT))
# # Be paranoid about syncing
# file_handle.sync = true
# # Hack the existing Rails.logger object to use our new file handle
# Rails.logger.instance_variable_set :@log, file_handle
# # Calls to Rails.logger go to the same object as Delayed::Worker.logger
# Delayed::Worker.logger = Rails.logger

Delayed::Worker.destroy_failed_jobs = false