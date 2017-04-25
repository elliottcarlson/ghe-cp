# ghe-make-backup 

A cronjob script to assist in performing nightly GitHub Enterprise backups,
uploading of the backup snapshot to AWS S3, and notify a Slack channel on the
status of the backup.

## Requirements

You will need the following installed and configured  on your backup machine:

* [GitHub Enterprise Backup Utilities](https://github.com/github/backup-utils)
* [AWS Command Line Interface](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)

Additionally, you will need to set up an incoming Webhook on your Slack instance:

* [Incoming Webhooks](https://my.slack.com/services/new/incoming-webhook/)

## Install

```
$ git clone https://github.com/elliottcarlson/ghe-make-backup
$ cd ghe-make-backup
$ make
Checking for GitHub Enterprise Backup Utilities...
Found in /home/ec2-user/backup-utils.
Checking for AWS CLI tools...
Installing daily crontab...
Enter the Slack Webhook URL that will receive Slack messages.
Slack Webhook URL: https://hooks.slack.com/services/XXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXXXXXX
Enter the Slack Channel to send messages to.
Slack Channel: #ghe-ops
Enter the AWS S3 bucket name to save snapshots to.
S3 Bucket: ga-ghe-backups
Saving .config.
Hour of day (24h format): 23
Minute: 30
$
```
