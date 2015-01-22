import urllib2
import json


# day = 0
data = urllib2.urlopen('http://54.148.89.48:8080/otp/routers/default/plan?fromPlace=-33.93310591314123%2C18.42128276824951&toPlace=-34.12708173633833%2C18.447933197021484&date=12-20-2014&time=09%3A13+AM&mode=TRANSIT%2CWALK&maxWalkDistance=800&arriveBy=false&wheelchair=false&showIntermediateStops=true')
dictionary = json.load(data)

print dictionary["plan"]["itineraries"][0]["legs"][0]["mode"]

# print ''

# print dictionary['daily']['data'][day]['summary']
# print dictionary['daily']['data'][day]['temperatureMax']



# [greeting : "hello", goodbye : "bye"]

# ["constania" : "22.000,13.0000", "claremont" : "33.0000,43.00000"]



