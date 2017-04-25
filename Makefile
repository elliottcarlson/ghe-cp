BASE_DIR := $(shell pwd)

# Find the backup-utils directory within $PATH pr $HOME
SEARCH_PATH = $(shell \
        echo $(PATH):$(HOME) | \
        tr ":" " " | \
        xargs readlink -f | \
        tr "\n" " " \
)
GHE_UTILS := $(shell \
        find $(SEARCH_PATH) -type d -name backup-utils -print -quit \
)
AWS_CLI := $(shell command -v aws 2>/dev/null)

all: requirements_check config install_crontab

requirements_check:
$(info Checking for GitHub Enterprise Backup Utilities...)
ifndef GHE_UTILS
$(error "GitHub Enterprise Backup Utilities not found.")
else
GHE_UTILS := $(shell readlink -f $(GHE_UTILS))
$(info Found in $(GHE_UTILS).)
endif

$(info Checking for AWS CLI tools...)
ifndef AWS_CLI
$(error "AWS CLI not found.")
endif

config:
	@while [ -z "$$SLACK_WEBHOOK" ]; do \
                echo Enter the Slack Webhook URL that will receive Slack messages.; \
                read -r -p "Slack Webhook URL: " SLACK_WEBHOOK; \
        done && \
        while [ -z "$$SLACK_CHANNEL" ]; do \
                echo Enter the Slack Channel to send messages to.; \
                read -r -p "Slack Channel: " SLACK_CHANNEL; \
        done && \
        while [ -z "$$S3_BUCKET" ]; do \
                echo Enter the AWS S3 bucket name to save snapshots to.; \
                read -r -p "S3 Bucket: " S3_BUCKET; \
        done && \
        ( \
                echo Saving .config.; \
                echo SLACK_WEBHOOK=$$SLACK_WEBHOOK > $(BASE_DIR)/.config; \
                echo SLACK_CHANNEL=$$SLACK_CHANNEL >> $(BASE_DIR)/.config; \
                echo UTILS_DIR=$(GHE_UTILS) >> $(BASE_DIR)/.config; \
                echo S3_BUCKET=$$S3_BUCKET >> $(BASE_DIR)/.config; \
        )

install_crontab:
	@while [ -z "$$CRONTAB_HOUR" ]; do \
                read -r -p "Hour of day (24h format): " CRONTAB_HOUR; \
        done && \
        while [ -z "$$CRONTAB_MINUTE" ]; do \
                read -r -p "Minute: " CRONTAB_MINUTE; \
        done && \
        ( \
                CRONTAB_NOHEADER=Y crontab -l || true; \
                printf "%s" \
                        "$$CRONTAB_MINUTE " \
                        "$$CRONTAB_HOUR " \
                        "* * * " \
                        "$(BASE_DIR)/make-backup.sh >>" \
                        "$(BASE_DIR)/backup-cron.log 2>&1"; \
                printf '\n') | crontab -
$(info Installing daily crontab...)
