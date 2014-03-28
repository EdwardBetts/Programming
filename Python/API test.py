import urllib2
import json
import binascii
import os

# print '3a2cc3492d234e773aa7db5f18819d1a0acb93de1e90cca4abd4473ab1c2d6sb'
# 3becb8fd26642ffe79c61599ed3fb9f61e9118163b43305be797b6a9d9272a4b


def main():
	key = binascii.b2a_hex(os.urandom(32))
	#try:
	data = urllib2.urlopen('https://coinbase.com/api/v1/account/balance?api_key=bf674af1ff938d50d84cc6394036f05b407a536b9405e6f8b8b2c3472c383ccd')
	dictionary = json.load(data)

	btc = float(dictionary['amount'])

	print btc #+ '\n SUCCESS ON KEY ' + key + '-----------------------------------------'
#except:
	#print 'fail ' + key

if __name__ == '__main__':
	main()