# Function to prompt user for GET or POST option
function selectgetpost {
    $selectoption = ""
    if (!$selectoption) {
        $selectoption = Read-Host -Prompt "Would you like to query an API? For GET press 1 For POST press 2"
    }
    return $selectoption
}

# Function to query API using GET request
function QueryApiGet($url, $headers = $null) {
    try {
        $response = Invoke-WebRequest -Uri $url -Method Get -Headers $headers
        $json = $response.Content | ConvertFrom-Json
        return $json
    }
    catch {
        Write-Error $_.Exception.Message
        return $null
    }
}

# Function to query API using POST request
function QueryApiPost($url, $body, $headers = $null) {
    try {
        $jsonBody = $body | ConvertTo-Json -Depth 4
        $response = Invoke-WebRequest -Uri $url -Method Post -Headers $headers -Body $jsonBody -ContentType 'application/json'
        $json = $response.Content | ConvertFrom-Json
        return $json
    }
    catch {
        Write-Error $_.Exception.Message
        return $null
    }
}

# Prompt user for GET or POST option
$selectoption = selectgetpost

# If user selects GET
if ($selectoption -eq '1') {
    # Prompt user for API URL
    $url = ""
    if (!$url) {
        $url = Read-Host -Prompt "Would URL would you like to GET?"
    }
    # Prompt user for headers
    $headers = ""
    if (!$headers) {
        $headers = Read-Host -Prompt "Would headers would you like to use/set? If none are required please enter nothing (just press enter)"
    }
    # Call QueryApiGet function with user input
    QueryApiGet $url $headers
}
# If user selects POST
elseif ($selectoption -eq '2') {
    # Prompt user for API URL
    $url = ""
    if (!$url) {
        $url = Read-Host -Prompt "Would URL would you like to POST?"
    }
    # Prompt user for body/data to POST
    $body = ""
    if (!$body) {
        $body = Read-Host -Prompt "What body / data would you like to POST?"
    }
    # Prompt user for headers
    $headers = ""
    if (!$headers) {
        $headers = Read-Host -Prompt "Would headers would you like to use/set? If none are required please enter nothing (just press enter)"
    }
    # Call QueryApiPost function with user input
    QueryApiPost $url $body $headers
}
# If user inputs an invalid option
else {
    "An error has ocurred."
}
