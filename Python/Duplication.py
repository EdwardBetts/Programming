import os
import hashlib

def chunk_reader (file_object, chunk_size=1024):
	while True:
		chunk = file_object.read(chunk_size)
		if not chunk:
			return
		else:
			yield chunk

def check_for_duplicates (path, ignore, hash = hashlib.sha1):
	hashes = {}
	for dirpath, dirname, filenames in os.walk(path):
		for filename in filenames:
			full_path = os.path.join(dirpath, filename)
			hash_object = hash()
			for chunk in chunk_reader(open(full_path, 'rb')):
				hash_object.update(chunk)
			file_id = (hash_object.digest(), os.path.getsize(full_path))
			duplicate = hashes.get(file_id, None)
			if os.path.getsize(full_path) > 50000:
				print duplicate
				if duplicate:
					print "Found = %s %s" % (full_path, duplicate)
				else:
					hashes[file_id] = full_path

ignore = {'.DS_Store', '.localized'}

check_for_duplicates('/Users/byroncoetsee/Documents', ignore)