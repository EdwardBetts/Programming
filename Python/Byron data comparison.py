# Written by Byron Coetsee
# 14/1/2014

import filecmp, shutil, os, sys, ctypes

country = 'Puerto Rico' # Paraguay, Puerto Rico, Nicaragua
 
SRC = r'O:\\' + country # BACKUP SERVER (OLD)
DEST = r'N:\\' + country # NEW SERVER

SizeDifs_Path = DEST + '\sizeDifs.txt'
Copies_Path = DEST + '\Copies.txt'
scanned_Path = DEST + '\Scanned.txt'
skipped_Path = DEST + '\Skipped.txt'

sizeDifs = open(SizeDifs_Path, 'w')

if os.path.isfile(Copies_Path):
    copies = open(Copies_Path, 'a')
else:
    copies = open(Copies_Path, 'w')

scanned = open(scanned_Path, 'w')
skipped = open(skipped_Path, 'w')
 
 # To ignore a filetype, enter it here. to ignore more than one, do " ['xxx.filetype', 'xxx.filtype2'] "
IGNORE = ['.jpg']
ignoreDirs = ['N:\Costa Rica', 'N:\Colombia', 'N:\Argentina', 'N:\Ecuador']
 
 # Creates the file/dir path
def get_cmp_paths(dir_cmp, filenames):
    return ((os.path.join(dir_cmp.left, f), os.path.join(dir_cmp.right, f)) for f in filenames)
 
 #syncs the folder
def sync(dir_cmp):

    # Removes files not present on destination - uncomment 'os.remove' and comment out 'pass'
    for f_left, f_right in get_cmp_paths(dir_cmp, dir_cmp.right_only):
        if os.path.isfile(f_right):
            pass
            #os.remove(f_right)

    #copies files and folders not already on the destination. Leaves source files/dirs intact
    for f_left, f_right in get_cmp_paths(dir_cmp, dir_cmp.left_only+dir_cmp.diff_files):
        if (f_left not in ignoreDirs) and (f_right not in ignoreDirs):
            if os.path.exists(f_right):
                if os.path.getsize(f_left) != os.path.getsize(f_right):
                    if os.path.getsize(f_left) > os.path.getsize(f_right):
                        sizeDifs.write ('\n' + f_left + '(OLD) *** > *** (NEW)' + f_right)
                    else:
                        sizeDifs.write ('\n' + f_left + '(OLD) *** < *** (NEW)' + f_right)
                else:
                    try:
                        if os.path.isfile(f_left):
                            print 'Copying ' + f_left + '.........'
                            shutil.copy2(f_left, f_right)
                            copies.write('\ncopy %s' % f_left)
                        else:
                            print 'Copying ' + f_left + '.........'
                            shutil.copytree(f_left, f_right)
                            copies.write('\ncopy %s' % f_left)
                    except shutil.Error:
                        ignoreDirs.append(f_left)
                        skipped.write(f_left + '\n')
                        print 'CORRUPT\t\t' + (f_left) + '\n'
                    except OSError:
                        ignoreDirs.append(f_left)
                        skipped.write(f_left + '\n')
                        print 'CORRUPT\t\t' + (f_left) + '\n'
                    except WindowsError:
                        ignoreDirs.append(f_left)
                        skipped.write(f_left + '\n')
                        print 'CORRUPT\t\t' + (f_left)
            else:
                if os.path.isfile(f_left):
                    try:
                        print 'Copying ' + f_left + '.........'
                        shutil.copy2(f_left, f_right)
                        copies.write('\ncopy %s' % f_left)
                    except shutil.Error:
                        ignoreDirs.append(f_left)
                        skipped.write(f_left + '\n')
                        print 'CORRUPT\t\t' + (f_left) + '\n'
                    except OSError:
                        ignoreDirs.append(f_left)
                        skipped.write(f_left + '\n')
                        print 'CORRUPT\t\t' + (f_left) + '\n'
                    except WindowsError:
                        ignoreDirs.append(f_left)
                        skipped.write(f_left + '\n')
                        print 'CORRUPT\t\t' + (f_left)
                else:
                    try:
                        print 'Copying ' + f_left + '.........'
                        shutil.copytree(f_left, f_right)
                        copies.write('\ncopy %s' % f_left)
                    except shutil.Error:
                        ignoreDirs.append(f_left)
                        skipped.write(f_left + '\n')
                        print 'CORRUPT\t\t' + (f_left) + '\n'
                    except OSError:
                        ignoreDirs.append(f_left)
                        skipped.write(f_left + '\n')
                        print 'CORRUPT\t\t' + (f_left) + '\n'
                    except WindowsError:
                        ignoreDirs.append(f_left)
                        skipped.write(f_left + '\n')
                        print 'CORRUPT\t\t' + (f_left)
        else:
            print 'Ignored ' + f_left
    for sub_cmp_dir in dir_cmp.subdirs.values():
        sync(sub_cmp_dir)

def check_filenames(path, oldNew):
    changed = 0
    for dirpath, dirnames, filenames in os.walk(path):
        index = 0
        for filename in dirnames:
            scanned.write (os.path.join(dirpath, filename) + '\n')
            try:
                for i in range(10):
                    if filename[0:1] == '_':
                        dir_path_Original = os.path.join(dirpath, filename)
                        filename = filename[1:]
                        print 'Removed _ from ' + filename + oldNew
                        changed = 1
                        dir_path_Changed = os.path.join(dirpath, filename)
                        os.rename(dir_path_Original, dir_path_Changed)

                    if filename[-3:] == '_CE':
                        print 'Removed CE from ' + filename + oldNew
                        changed = 1
                        dir_path_Original = os.path.join(dirpath, filename)
                        filename = filename[:-3]
                        dir_path_Changed = os.path.join(dirpath, filename)
                        os.rename(dir_path_Original, dir_path_Changed)

                    if filename[-3:] == '_CM':
                        print 'Removed CM from ' + filename + oldNew
                        changed = 1
                        dir_path_Original = os.path.join(dirpath, filename)
                        filename = filename[:-3]
                        dir_path_Changed = os.path.join(dirpath, filename)
                        os.rename(dir_path_Original, dir_path_Changed)
                    if changed == 1:
                        dirnames[index] = filename
                    index = index + 1
            except OSError:
                ignoreDirs.append(os.path.join(dirpath, filename))
                skipped.write(os.path.join(dirpath, filename) + '\n')
                print 'PERMISSIONS\t\t' + (os.path.join(dirpath, filename) + '\n')
            except WindowsError:
                ignoreDirs.append(os.path.join(dirpath, filename))
                skipped.write(os.path.join(dirpath, filename))
                print 'PERMISSIONS\t\t' + (os.path.join(dirpath, filename))


 # Checks if source is a single file or if the dir doesnt exist. 
def sync_files(src, dest, ignore=IGNORE):
    if not os.path.exists(src):
        print('Source directory does not exist')
        print('Sync failure')
        return

    if os.path.isfile(src):
        print('Dont be lazy - copy the file yourself...')
        print('Sync failure')
        return

    #check_filenames(src, ' ****OLD')
    #scanned.write("OLD DONE")
    #check_filenames(dest, ' ****NEW')
    #scanned.write("NEW DONE")
    #print 'NEW DONE'
    

    if not os.path.exists(dest):
        os.makedirs(dest)    
    dir_cmp = filecmp.dircmp(src, dest, ignore=IGNORE)
    sync(dir_cmp)
    print('----------Synced-----------')
    ctypes.windll.user32.MessageBoxA(0, "DONE!", "Sync Complete", 1)

 
if __name__ == '__main__':
    src, dest = SRC, DEST
    if len(sys.argv) == 3:
        src, dest = sys.argv[1:3]
    sync_files(src, dest)
    sizeDifs.write('\n\n************END*************')
    sizeDifs.close()
    copies.write('\n\n************END*************')
    copies.close()
    skipped.write('\n\n************END*************')
    skipped.close()