import urllib2
import json
import time

data = urllib2.urlopen('https://bitx.co.za/api/1/BTCZAR/ticker')
dictionary = json.load(data)


print 'Timestamp:\t' + str(time.strftime('%H:%M:%S', time.gmtime(float((dictionary['timestamp'])/1000)+7200)))
print 'Bid:\t\t\t' + dictionary['bid']
print 'Ask:\t\t\t' + dictionary['ask']
print 'Last:\t\t\t' + dictionary['last_trade']
print 'Volume (24hr):\t' + ('%.2f' % float(dictionary['rolling_24_hour_volume']))
print '-------------------------'

last_trade = float(dictionary['last_trade'])

data = urllib2.urlopen('https://coinbase.com/api/v1/account/balance?api_key=3a2cc3492d234e773aa7db5f18819d1a0acb93de1e90cca4abd4473ab1c2d5cf')
dictionary = json.load(data)

btc = float(dictionary['amount'])

print '' + str(btc) + 'BTC\t:\t' + str(btc * last_trade) + ' ZAR'
print 

print '-------------------------'