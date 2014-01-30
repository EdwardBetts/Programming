# Written by Byron Coetsee
# 22/01/2014

import os

corrupt_files = open(os.path.dirname(os.path.realpath(__file__)) + '\Michelle_File_Count.txt', 'wb')

path = os.path.dirname(os.path.realpath(__file__))
for dirpath, dirname, filename in os.walk(path):
	#print filename
	if len(filename) < 18 and 'LC8' in dirpath:
		print dirpath + ' = ' + str(len(filename))
		corrupt_files.write(dirpath + ' = ' + str(len(filename)) + '\n')

corrupt_files.close()