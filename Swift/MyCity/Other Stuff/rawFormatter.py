with open('/Users/byroncoetsee/Documents/XCode/ClosestStops/formatted.txt') as f:
	lines = f.readlines()

save = open('/Users/byroncoetsee/Documents/XCode/ClosestStops/stop_names.txt', 'w')

# for line in lines:
# 	line = line.strip()
# 	line = line.replace("</option>", "")
# 	line = line.replace("<option value=\"\" data-lat=\"", "")
# 	line = line.replace("\" data-long=\"", ",")
# 	line = line.replace("\">", ",")
# 	# line = line.strip()
# 	# data = line.split(',')
# 	save.write(line+'\n')
# 	# save.write(data[2] + '\n' + data[0] + '\n' + data[1] + '\n')

for line in lines:
	tempLine = line.split(',')
	save.write(tempLine[2])
	print tempLine[2]