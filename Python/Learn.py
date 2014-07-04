routes = ['101']#, '102', '103', '104', '105', '106', '107', '108', '109', '113', '213', '2131', '214', '215', '216', '217', '230', '231', '232', '233', '236', '239', '251', '2001', '1001', '1003']
stopsWithDistances = {}
currentRoute = []

def countBackards(currentStop):
	position = currentRoute.index(currentStop)
	return position

def countForwards(currentStop):
	pass

for route in routes:
	with open('/Users/byroncoetsee/Documents/Programming/Swift/MyCity/ClosestStops/StopDetails/Routes/' + route + '/stopNames.txt') as f:
		lines = f.readlines()

	currentRoute = lines[0].split(';') # Fetches the stop names for that route and puts them into array

	for stop in currentRoute:
		print countBackards(stop)

	