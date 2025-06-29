
function Api(){
  __init__(){
    shopt -s expand_aliases
    alias in.api="Api.Main.in_api"
    alias res.api="Api.Main.res_api"
    alias run.api="Api.Main.run"
    
    API_URL="http://api.multibot.in"
    API_KEY="YWNSXD4zPx5GLoHJBrnp89seQj6adcfM"
    MAX_WAIT=300
    SLEEP=5
  }
  
  Main(){
    :
  }
  
  Api.Main.in_api(){
    local data="$1"
    local params="key=$API_KEY&json=1"
    for key in $data; do
      params+="&$key=$data[$key]"
    done
    local response=$(curl -s -X POST \
      -H "Content-Type: application/x-www-form-urlencoded" \
      --data "$params" \
      --max-time 5 \
      "$API_URL/in.php")
    echo "$response"
  }
  
  Api.Main.res_api(){
    local api_id="$1"
    local response=$(curl -sL -X GET \
      -H "Content-Type: application/x-www-form-urlencoded" \
      --max-time 5 \
      "$API_URL/res.php?key=$API_KEY&id=$api_id&json=1")
    echo "$response"
  }
  
  Api.Main.run(){
    local data="$1"
    local get_in=$(in.api "$data")
    if [ $? -eq 0 ]; then
      local status=$(echo "$get_in" | jq -r '.status')
      if [ "$status" = "true" ]; then
        local api_id=$(echo "$get_in" | jq -r '.request')
        for ((i=0; i<$MAX_WAIT/$SLEEP; i++)); do
          sleep $SLEEP
          local get_res=$(Api.Main.res_api "$api_id")
          if [ $? -eq 0 ]; then
            local answer=$(echo "$get_res" | jq -r '.request')
            if [[ "$answer" != *"CAPCHA_NOT_READY"* ]]; then
              echo "$answer"
              return
            fi
          fi
        done
      else
        echo $(echo "$get_in" | jq -r '.request')
        return
      fi
    else
      echo "WRONG_RESPONSE_API"
      return
    fi
  }
  __init__
}

dst=$(curl -sL "https://mitratopserver.com/captcha" --insecure|base64|tr -d "\n")
# Example usage
Api
data="method=universal&body=$dst"
ds=$(run.api "$data")
curl -sLX GET "http://api.multibot.in/res.php?key=YWNSXD4zPx5GLoHJBrnp89seQj6adcfM&id=${ds}&json=1"
