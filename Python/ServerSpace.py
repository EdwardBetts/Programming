# Written by Byron Coetsee
# 17/01/2014

import pxssh
import sys

save_path = os.path.dirname(os.path.realpath(__file__))
output = open(save_path+'/Server_Space.txt', 'w')
output.close()

hosts = ['192.168.0.15', '192.168.0.19', '192.168.0.20', '192.168.0.203', '192.168.0.205']
QNAP_hosts = ['192.168.0.6', '192.168.0.7', '192.168.0.9', '192.168.0.11', '192.168.0.12', '192.168.0.16', '192.168.0.17', '192.168.0.204']
password = 'Bl0ckC'

def connect(host, user, password, command):
	try:
		s = pxssh.pxssh()
		s.login(host, user, password)
		print 'Logged in to '+host+'...'
		print '---------------------------------------------------------------'

		output = open(save_path+'/Server_Space.txt', 'a')
		output.write('---------------------------------------------------------------\n')
		output.close()

		s.sendline('hostname')
		s.prompt()
		print s.before

		output = open(save_path+'/Server_Space.txt', 'a')
		output.write(host + '\n' + str(s.before))
		output.close()

		s.sendline(command)
		s.prompt()
		print s.before

		output = open(save_path+'/Server_Space.txt', 'a')
		output.write(str(s.before))
		output.close()

		s.logout()

		print '---------------------------------------------------------------'
		output = open(save_path+'/Server_Space.txt', 'a')
		output.write('---------------------------------------------------------------\n')
		output.close()


	except Exception, e:
		print 'Error Connecting - ' + str(e)

if __name__ == '__main__':

	for item in hosts:
		connect(item, 'root', password, 'df -h')

	for item in QNAP_hosts:
		connect(item, 'admin', password, 'df')

	output = open(save_path+'/Server_Space.txt', 'a')
	output.write('\n\nDONE')
	output.close()
