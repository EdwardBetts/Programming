from bs4 import BeautifulSoup
from urllib2 import urlopen
import os

# routes = ['101', '102', '103', '104', '105', '106', '107', '108', '109', '113', '213', '2131', '214', '215', '216', '217', '230', '231', '232', '233', '236', '239', '251', '2001', '1001', '1003']
routes = ['239']
days = ["Monday", "Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]



for route in routes:
	print '--- ' + route + ' ---'
	with open ("/Users/byroncoetsee/Documents/XCode/ClosestStops/StopDetails/Routes/" + route + "/stopNames.txt") as f:
		currentRouteStopNames = f.readlines()

	with open ("/Users/byroncoetsee/Documents/XCode/ClosestStops/StopDetails/Routes/" + route + "/stopNames.txt") as f:
		currentRouteStopNamesReversed = f.readlines()

	try:
		stopNames = currentRouteStopNames[0].split(';')
		numberOfStops = len(currentRouteStopNames[0].split(';'))

		for day in days: # Getting times of that day and route
			for direction in range(0,2):
				if direction == 1:
					stopNames = currentRouteStopNamesReversed[0].split(';')
				else:
					stopNames = currentRouteStopNames[0].split(';')
				numberOfStops = len(currentRouteStopNames[0].split(';'))

				url = 'http://www.myciti.org.za/en/timetables/route-stop-timetables/?timetable[weekday]=' + day + '&timetable[route_id]=' + route + '&timetable[direction]=' + str(direction)
				page = urlopen(url)
				soup = BeautifulSoup(page.read())
				names = soup.findAll('span')


				timeGrid = []
				count = 0
				output = []
				print day
				for tag in names:
					try:
						if len(tag.string) == 5 or tag.string == ':':
							output.append(tag.string)
							count += 1
							if count == numberOfStops:
								timeGrid.append(output)
								output = []
								count = 0
					except TypeError:
						pass
				rotated = zip(*timeGrid)

				output = ''
				if direction == 0:
					save = open('/Users/byroncoetsee/Documents/XCode/ClosestStops/StopDetails/Routes/' + route + '/' + day + '.txt', 'w')
				else:
					save = open('/Users/byroncoetsee/Documents/XCode/ClosestStops/StopDetails/Routes/' + route + '/' + day + 'Reversed.txt', 'w')
				for line in rotated:
					for val in line:
						output = output + str(val) + ','
					save.write(output[:-1] + '\n')
					count += 1
					output = ''
				save.close()
	except IndexError:
		pass

