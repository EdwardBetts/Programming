from bs4 import BeautifulSoup
from urllib2 import urlopen
import os
import numpy

with open ("/Users/byroncoetsee/Documents/XCode/ClosestStops/formatted.txt") as f:
	temp = f.readlines()

listOfStopNames = []

for line in temp:
	t = line.split(',')
	listOfStopNames.append(t[2].strip())

routes = ['101', '102', '103', '104', '105', '106', '107', '108', '109', '113', '213', '2131', '214', '215', '216', '217', '230', '231', '232', '233', '236', '239', '251', '2001', '1001', '1003']
# routes = ['239']

stops = {}
stopsWithRoutes = {}

for direction in range(0,2):
	for route in routes:
		print route
		url = 'http://www.myciti.org.za/en/timetables/route-stop-timetables/?timetable[weekday]=monday&timetable[route_id]='+ route + '&timetable[direction]=' + str(direction)

		page = urlopen(url)
		soup = BeautifulSoup(page.read())

		names = soup.findAll('small')
		nameStrings = []

		output = ''

		for tag in names:
			tagStr = str(tag.string)
			valid = True
			if tagStr.find('Share') != -1: valid = False
			if tagStr.find('View System Map') != -1: valid = False
			if tagStr.find('class=') != -1: valid = False
			if valid == True:
				nameStrings.append(tag.string)
				output = output + tag.string + ';'

		if not os.path.exists('/Users/byroncoetsee/Documents/XCode/ClosestStops/StopDetails/Routes/' + route):
			os.makedirs('/Users/byroncoetsee/Documents/XCode/ClosestStops/StopDetails/Routes/' + route)

		if direction ==  0:
			save = open('/Users/byroncoetsee/Documents/XCode/ClosestStops/StopDetails/Routes/' + route + '/stopNames.txt', 'w')
		else:
			save = open('/Users/byroncoetsee/Documents/XCode/ClosestStops/StopDetails/Routes/' + route + '/stopNamesReveresed.txt', 'w')
		save.write(output[:-1])
		save.close()

		page = urlopen(url)
		soup = BeautifulSoup(page.read())

		# names = soup.findAll('span')
		addingNames = [] # stop names which will be added to an already present route
		if route in stops: # If current route is already in the list
			for nameString in nameStrings: # Looping through stop names of current route
				if nameString not in stops[route]:
					stops[route].append(nameString)
					# addingNames.append(nameString) # Adding current stop name to list which will then be added to an already present route
			# stops[route]
		else:
			stops[route] = nameStrings
		print route + ' --- ' + str(stops[route])

for line in listOfStopNames: # Looping through stop names
	listOfNumbers = [] # Array holding routes which run through the current stop
	for number, stopNames in stops.iteritems(): # number = 108, stopNames = stops for that route
		if line in stopNames: # If stop name is in current routes path
			listOfNumbers.append(number) # Add number to Array holding routes
	stopsWithRoutes[line] = listOfNumbers # Dictionary holding stop names with the routes which run through them

for stopName, routeNumbers in stopsWithRoutes.iteritems(): # List of all the stop names with their route numbers
	save = open('/Users/byroncoetsee/Documents/XCode/ClosestStops/StopDetails/Stops/' + stopName + '.txt', 'w')
	for num in routeNumbers: # Loop through route numbers of specific stop
		save.write(num + '\n')
	save.close()







