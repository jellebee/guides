# Import necessary libraries, you might need to install them first
import json

import requests


# Function to prompt user for API query option
def select_get_post():
    select_option = ""
    if not select_option:
        select_option = input("Would you like to query an API? For GET press 1 For POST press 2: ")
    return select_option

# Function to make GET request to API
def query_api_get(url, headers=None):
    try:
        # Send GET request to API with URL and optional headers
        response = requests.get(url, headers=headers)
        # Convert response content to JSON format
        json_response = response.json()
        # Return JSON response
        return json_response
    except Exception as e:
        # If an error occurs during the request, print the error message and return None
        print(e)
        return None

# Function to make POST request to API
def query_api_post(url, body, headers=None):
    try:
        # Serialize the body as JSON
        json_body = json.dumps(body)
        # Send POST request to API with URL, serialized JSON body, and optional headers
        response = requests.post(url, headers=headers, data=json_body)
        # Convert response content to JSON format
        json_response = response.json()
        # Return JSON response
        return json_response
    except Exception as e:
        # If an error occurs during the request, print the error message and return None
        print(e)
        return None

# Prompt user for API query option
select_option = select_get_post()

# If user chooses GET option
if select_option == "1":
    # Prompt user for API URL and headers
    url = input("What URL would you like to GET? ")
    headers = input("What headers would you like to use/set? If none are required please enter nothing (just press enter) ")
    # Call query_api_get function with URL and headers
    result = query_api_get(url, headers=headers)
    # Print the JSON response
    print(result)
    
# If user chooses POST option
elif select_option == "2":
    # Prompt user for API URL, body, and headers
    url = input("What URL would you like to POST? ")
    body = input("What body/data would you like to POST? ")
    headers = input("What headers would you like to use/set? If none are required please enter nothing (just press enter) ")
    # Call query_api_post function with URL, body, and headers
    result = query_api_post(url, body, headers=headers)
    # Print the JSON response
    print(result)
    
# If user chooses neither GET nor POST option
else:
    print("An error has occurred.")
