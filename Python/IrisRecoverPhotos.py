import os
import zipfile

path = '/Users/byroncoetsee/Desktop/Iris/'

for dirpath, dirnames, filenames in os.walk(path):
	for filename in filenames:

		# REMOVING THE EXTRACTED PART OF THE FILENAME
		oldName = os.path.join(dirpath, filename)
		newName = os.path.join(dirpath, filename[filename.rindex('\\')+1:])
		os.rename(oldName, newName)


		# EXTRACTING ZIP FILES AND DELETING THEM
		# filePath = os.path.join(dirpath, filename)
		# savePath = filePath[:filePath.rindex('/')+1]
		# try:
		# 	with zipfile.ZipFile (filePath, 'r') as zip:
		# 		zip.extractall(path=savePath)

		# 	os.remove(filePath)

		# except zipfile.BadZipfile:
		# 	print filename


		# RENAMEING OF FILES TO ZIP
		# if '.nco' in filename:
		# 	oldName = os.path.join(dirpath, filename)
		# 	newName = os.path.join(dirpath, filename[:-7]+'zip')

		# 	if 'Thumbs' not in filename:
		# 		oldName = os.path.join(dirpath, filename)
		# 		newName = os.path.join(dirpath, filename[:-7]+'zip')
		# 		os.rename(oldName, newName)
		# 		print filename
		# 	else:
		# 		print filename