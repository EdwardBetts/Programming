import urllib2
import json
from time import *

data = urllib2.urlopen('https://bitx.co.za/api/1/BTCZAR/trades')
dictionary = json.load(data)


print 'RECENT TRADES'
print '---'+str(strftime("%H:%M:%S", gmtime(time() + 7200)))+'---'
print '{0:15}{1:15}{2}'.format('Time','Price','Amount')
print ''

# print '{0:15}{1:15}{2}'.format('10:53:23',
# 		'9600.00',
# 		'1.00004')

for i in range(15):
	#time = str(time.strftime('%H:%M:%S', time.gmtime(float((dictionary['trades'][0]['timestamp'])/1000)+7200)))
	print '{0:15}{1:15}{2}'.format(str(strftime('%H:%M:%S', gmtime(float((dictionary['trades'][i]['timestamp'])/1000)+7200))),
		dictionary['trades'][i]['price'],
		dictionary['trades'][i]['volume'])