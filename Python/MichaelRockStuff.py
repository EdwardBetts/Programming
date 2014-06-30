import re

# SiO2
# Al2O3
# TiO2
# K2O
# Na2O
# MnO
# CaO
# MgO
# Cr2O3
# FeO

mol_weight = [60.08, 101.96, 79.88, 94.20, 61.98, 70.94, 56.08, 40.30, 151.99, 71.85]
oxy_per_mol = [2,3,2,1,1,1,1,1,3,1]


with open('C:\Users\Michael\Desktop\Microprobe data\Quartz-Mica Mylonites/MICAS_test.txt') as f:
	lines = f.readlines()

data = []

for record in lines:
	if len(record.split()) > 12:
			data.append(record.split())

for line in data:
	for count in range(len(line)):
		if '-' in line[count]:
			line.pop(count)
			line.insert(count, '0')
	# print line

count = 0

iterdata = iter(data)
next(iterdata)
lists = []
for line in iterdata:

	iterelement = iter(line)
	next(iterelement)
	print '----------------'+ str(line[12]) + '-----------------'
	for element in iterelement:
		if count < 10:
			print data[0][count+1] + '\t\t' + str(float(element) / mol_weight[count])
			count = count + 1
	count = 0
	



