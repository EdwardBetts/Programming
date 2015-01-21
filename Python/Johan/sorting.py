# -*- coding: utf-8 -*-

# requires the following libraries to be installed:
#		lxml
#		BeautifulSoup

from bs4 import BeautifulSoup
import os
import collections

c = 'c04'
save = open(os.path.join(os.path.dirname(os.path.realpath('___file___')),'Results.xml'), 'w')
tableData = {}
insertInto = {} # C04

url = os.path.join(os.path.dirname(os.path.realpath('___file___')),'Bylaag XI 2.13.01 toets.xml')
soup = BeautifulSoup(open(url), 'xml')
names = soup.findAll(c) # no duplicates

for s in soup(c):
	s.extract()

for s in soup:
	headerFooter = str(s)

headerFooter = ' '.join(headerFooter.split())
nextC = '</c0' + str(int(c[2:]) - 1) + '>'

save.write(headerFooter[:headerFooter.rfind(nextC)])
print headerFooter[:headerFooter.rfind(nextC)]

for name in names:
	insertInto[name.unitid.string] = str(name)

insertInto = collections.OrderedDict(sorted(insertInto.items()))

url = os.path.join(os.path.dirname(os.path.realpath('___file___')),'Bylaag-3 Toets-100-finaal.xml')
soup = BeautifulSoup(open(url), 'xml')
names = soup.findAll('inskrywing') # possible duplicates

count = 0

for name in names:
	try:
		if tableData[name.find('ID-nr').string]:
			print 'Duplicate ---- ' + name.find('ID-nr').string
		count += 1
		tableData[name.find('ID-nr').string] = tableData[name.find('ID-nr').string][:-15] + str(name.scopecontent)[14:]
	except KeyError:
		tableData[name.find('ID-nr').string] = str(name.scopecontent)

for idNumber, record in insertInto.iteritems():
	try:
		save.write(record.replace('<invgTabel>TT</invgTabel>', tableData[idNumber]))
	except KeyError:
		save.write(record.replace('<invgTabel>TT</invgTabel>', ''))

print count
save.write(headerFooter[headerFooter.rfind(nextC):])
print headerFooter[headerFooter.rfind(nextC):]
save.close()