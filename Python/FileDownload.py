import urllib
import os

with open('/Users/byroncoetsee/Documents/Programming/Python/PHP/TreeCoverDone.txt') as f:
	done = f.readlines()

with open('/Users/byroncoetsee/Documents/Programming/Python/PHP/TreeCover.txt') as f:
	urls = f.readlines()

for url in urls:
	if url not in done:

		successful = False
		
		while not successful:
			tempFile = urllib.URLopener()
			print 'GETTING\t' + url
			tempFile.retrieve(url, ('/Users/byroncoetsee/Documents/Programming/Python/PHP/TreeCover\\' + url.split('/')[-1])[:-1])

			meta = tempFile.info()
			size = meta.getheader("Content-Length")

			if os.path.getsize(('/Users/byroncoetsee/Documents/Programming/Python/PHP/TreeCover\\' + url.split('/')[-1])[:-1]) == size:
				doneFile = open('/Users/byroncoetsee/Documents/Programming/Python/PHP/TreeCoverDone.txt', 'a')
				doneFile.write(url)
				doneFile.close()
				successful = True
			else:
				print 'Size mismatch! Redownloading ' + url

	else:
		print 'DONE ' + url

print '================DONE================'