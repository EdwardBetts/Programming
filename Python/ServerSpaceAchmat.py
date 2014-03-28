# Written by Byron Coetsee
# 21/01/2014

import pxssh
import sys
import os

save_path = os.path.dirname(os.path.realpath(__file__))
output = open(save_path+'/Server_Space_Summery.csv', 'w')
output.close()

hosts = ['192.168.0.15', '192.168.0.16', '192.168.0.9', '192.168.0.19', '192.168.0.12', '192.168.0.6', '192.168.0.205', '192.168.0.204', '192.168.0.17', '192.168.0.11', '192.168.0.203', '192.168.0.20', '192.168.0.7', '192.168.0.14', '192.168.0.10']
arena = ['192.168.0.15', '192.168.0.19', '192.168.0.20', '192.168.0.203', '192.168.0.205']
QNAP = ['192.168.0.6', '192.168.0.7', '192.168.0.9', '192.168.0.10', '192.168.0.11', '192.168.0.12', '192.168.0.14', '192.168.0.16', '192.168.0.17', '192.168.0.204']
password = 'Bl0ckC'

def connect(host, user, password, command):
	try:
		s = pxssh.pxssh()
		s.login(host, user, password)

		s.sendline('hostname')
		s.prompt()

		output = open(save_path+'/Server_Space_Summery.csv', 'a')
		hostname = (s.before).replace('hostname', '')[2:-2]

		s.sendline(command)
		s.prompt()

		temp = str(s.before).replace(command, '')[2:]

		temp = temp[temp.find('on') + 2:-2]

		dataList = temp.split()

		temp = ''
		count = 0

		if len(dataList) > 6:
			reps = len(dataList) / 6
			for x in range(0, reps):
				for k in range(0, 6):
					temp = temp + dataList[count] + ','
					count = count + 1
				print  hostname + ',' + temp[:-1] + ',' + host
				output.write(hostname + ',' + temp[:-1] + ',' + host)
				output.write('\n')
				temp = ''
		else:
			for word in dataList:
				temp = temp + word + ','

			output.write(hostname + ',' + temp[:-1] + ',' + host)
			print hostname + ',' + temp[:-1] + ',' + host

			output.write('\n')
		output.close()
		s.logout()

	except Exception, e:
		print 'Error Connecting - ' + str(e)

if __name__ == '__main__':

	output = open(save_path+'/Server_Space_Summery.csv', 'a')
	output.write('Host Name,Filesystem,Size,Used,Available,Use%,Mounted On,IP\n')
	output.close()

	for item in hosts:
		if item in arena:
			if item == '192.168.0.20':
				connect(item, 'root', password, 'df -h -P')
			elif item == '192.168.0.203':
				connect(item, 'root', password, 'df -h -P')
			elif item == '192.168.0.205':
				connect(item, 'root', password, 'df -h -P')
			else:
				connect(item, 'root', password, 'df -h -P')
		if item in QNAP:
			connect(item, 'admin', password, 'df')

	output = open(save_path+'/Server_Space_Summery.csv', 'a')
	output.write('\n\nDONE')
	output.close()
