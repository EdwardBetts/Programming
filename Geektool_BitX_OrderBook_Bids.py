import urllib2
import json
from time import *

data = urllib2.urlopen('https://bitx.co.za/api/1/BTCZAR/orderbook')
dictionary = json.load(data)

print 'BIDS (to buy)'
print '---'+str(strftime("%H:%M:%S", gmtime(time() + 7200)))+'---'
print '{0:15}{1}'.format('Price','Amount')
print ''

for i in range(15):
	print '{0:15}{1}'.format(dictionary['bids'][i]['price'],
		dictionary['bids'][i]['volume'])