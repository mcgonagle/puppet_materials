class cron::production_cron_jp inherits cron {
  	include cron_dailymessagetablescleanup
  	include cron_csr_update
  	include cron_manhunt_minute
  	include cron_manhunt_daily
  	include cron_phpadsnew_maintenance
  	include cron_roll_status_daily
  	include cron_updatecount_jp
}
