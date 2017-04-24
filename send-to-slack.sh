## Function to send a message to Slack
function _send_to_slack() {
    NOTICE=$(echo $1 | sed 's/"/\"/g' | sed "s/'/\'/g")
    JSON="{\"channel\": \"${SLACK_CHANNEL}\", \"text\": \"${NOTICE}\" }"

    curl -s -d "payload=${JSON}" "${SLACK_WEBHOOK}" &>/dev/null
}
