import urllib2
import json


day = 0
data = urllib2.urlopen('https://api.forecast.io/forecast/a5e6b097fa6e7b40ee7f51e78512930d/-33.9350,18.5200?units=si')
dictionary = json.load(data)

print dictionary['daily']['data'][day]

print ''

print dictionary['daily']['data'][day]['summary']
print dictionary['daily']['data'][day]['temperatureMax']



# [greeting : "hello", goodbye : "bye"]

["constania" : "22.000,13.0000", "claremont" : "33.0000,43.00000"]



