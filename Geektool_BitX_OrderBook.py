import urllib2
import json
from time import *

data = urllib2.urlopen('https://bitx.co.za/api/1/BTCZAR/orderbook')
dictionary = json.load(data)

print 'ASKS (to sell) NB!!'
print '---'+str(strftime("%H:%M:%S", gmtime(time() + 7200)))+'---'
print '{0:15}{1}'.format('Price','Amount')
print ''

for n in range(15):
	print '{0:15}{1}'.format(dictionary['asks'][n]['price'],
		dictionary['asks'][n]['volume'])