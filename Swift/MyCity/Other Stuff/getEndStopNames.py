routes = ['101', '102', '103', '104', '105', '106', '107', '108', '109', '113', '213', '2131', '214', '215', '216', '217', '230', '231', '232', '233', '236', '239', '251', '2001', '1001', '1003']

for route in routes:
	for direction in range(0,2):

		lines = []
		if direction == 0:
			with open('/Users/byroncoetsee/Documents/XCode/ClosestStops/StopDetails/Routes/' + route + '/stopNames.txt') as f:
				lines = f.readlines()
		else:
			with open('/Users/byroncoetsee/Documents/XCode/ClosestStops/StopDetails/Routes/' + route + '/stopNamesReveresed.txt') as f:
				lines = f.readlines()

		try:
			stops = lines[0].split(';')
			last = len(stops) - 1

			if direction == 0:
				save = open('/Users/byroncoetsee/Documents/XCode/ClosestStops/StopDetails/Routes/' + route + '/endStopNames.txt', 'w')
			else:
				save = open('/Users/byroncoetsee/Documents/XCode/ClosestStops/StopDetails/Routes/' + route + '/endStopNamesReversed.txt', 'w')
			save.write(stops[0] + ',' + stops[last])
		except IndexError:
			pass