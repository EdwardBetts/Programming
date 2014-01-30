# Written by Byron Coetsee
# 23/01/2014

import csv, os

paths = ['A:\\','I:\\','J:\\','K:\\','L:\\','M:\\','N:\\','O:\\','P:\\','Q:\\','R:\\','S:\\','T:\\','U:\\','V:\\','W:\\','X:\\','Y:\\']

csvfile = open('C:\Users\Jason\Desktop\Michelle_Numbers.csv', 'wb')
spamwriter = csv.writer(csvfile, delimiter=',', quoting=csv.QUOTE_MINIMAL)

dic = {}

for x in xrange(2396,3050):
	dic.update({str(x):''})

def add_paths(path):

	for dirpath, dirname, filename in os.walk(path):
		for name in dirname:
			tempString = ''
			try:
				tempString = name[name.index('_')+1:]
				tempString = tempString[:tempString.index('_')]

				if len(tempString) == 4:
					int(tempString)
					dic[tempString] = str(os.path.join(dirpath, name))
					print tempString + ' : ' + str(os.path.join(dirpath, name))
			except ValueError, TypeError:
				pass

for path in paths:
	add_paths(path)

for key, value in dic.items():
	try:
		skey = str(key)
		svalue = str(value)
		server_name = ''
		if 'A' in svalue[:1]:
			server_name = 'Africa 1 - Africa Northern'
		elif 'I' in svalue[:1]:
			server_name = 'MEA 3 - MidEast Asia 3'
		elif 'J' in svalue[:1]:
			server_name = 'MEA 3 - Current Projects'
		elif 'K' in svalue[:1]:
			server_name = 'MEA 2 - MidEast Asia 2'
		elif 'L' in svalue[:1]:
			server_name = 'MEA 2 - Current Projects'
		elif 'M' in svalue[:1]:
			server_name = 'MEA 1 - MidEast Asia 1'
		elif 'N' in svalue[:1]:
			server_name = 'MEA 1 - Current Projects'
		elif 'O' in svalue[:1]:
			server_name = 'Europe - Europe'
		elif 'P' in svalue[:1]:
			server_name = 'Europe - America Southern'
		elif 'Q' in svalue[:1]:
			server_name = 'America 3 - Current Projects'
		elif 'R' in svalue[:1]:
			server_name = 'America 3 - America Southern'
		elif 'S' in svalue[:1]:
			server_name = 'America 2 - America Southern'
		elif 'T' in svalue[:1]:
			server_name = 'America 2 - America Southern'
		elif 'U' in svalue[:1]:
			server_name = 'America 1 - Current Projects'
		elif 'V' in svalue[:1]:
			server_name = 'America 1 - America Northern'
		elif 'W' in svalue[:1]:
			server_name = 'Africa 2 - Current Projects'
		elif 'X' in svalue[:1]:
			server_name = 'Africa 2 - Africa Southern'
		elif 'Y' in svalue[:1]:
			server_name = 'Africa 1 - Current Projects'

		spamwriter.writerow([skey, svalue, server_name])
	except csv.Error:
		pass

csvfile.close()