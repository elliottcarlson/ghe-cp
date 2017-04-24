#!/bin/bash
## Test that Slack communication is working with saved .config

## Read configuration file, if it exists
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ ! -f $DIR/.config ]; then
    echo "Script has not been configured yet; did you run make?"
    exit 1
fi
source $DIR/.config

## Include Slack sending functionality
source $DIR/send-to-slack.sh

## Send test message to slack.
_send_to_slack "Testing Slack Integration"
