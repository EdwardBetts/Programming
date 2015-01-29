import urllib2
import json


# day = 0
data = urllib2.urlopen('http://54.148.89.48:8080/otp/routers/ZA_11/index/stops')
dictionary = json.load(data)

print dictionary[0]

# print dictionary["plan"]["itineraries"][0]["legs"][0]["mode"]

# print ''

# print dictionary['daily']['data'][day]['summary']
# print dictionary['daily']['data'][day]['temperatureMax']



# [greeting : "hello", goodbye : "bye"]

# ["constania" : "22.000,13.0000", "claremont" : "33.0000,43.00000"]



