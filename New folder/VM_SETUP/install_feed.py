"""
This script is mainly intended to install package from
the given repo path or package path
"""

import os
import re
import sys
import time
import urllib
import urllib2
import _winreg
import urlparse
import optparse
import xml.etree.cElementTree


WINERRORS = {
    'ERROR_FILE_NOT_FOUND': 2L,
    'ERROR_PATH_NOT_FOUND': 3L,
    'ERROR_INVALID_PARAMETER': 87L,
    'INET_E_INVALID_URL': 0x80072EE4L
}
NIPackageManagerProcessName = "NIPackageManager.exe"
NIPackageManagerInstallerDir = r"\\us-aus-argo\ni\nipkg\Package Manager"
NIPackageManagerDefaultInstallerPath = \
    r"\\us-aus-argo\NISoftwareReleased\Windows\Distributions\Package Manager\18.0\18.0.2\Install.exe"

ignoredErrCode = [-125071]
'''''
Refer to nipkg return code for more details:
    Perforce://AST/PackageManagement/components/shared/trunk/16.6/templates/errors.yml
+-------------------------------------------------+
|         Code        |          Mnemonic         |
+=================================================+
|       -125071       |       reboot_needed       |
+-------------------------------------------------+
'''''
class VersionError(Exception):
    pass

class PackageVersion(object):
    """ 1.0.0.0-0+d0 alike version strings
    """

    #
    # The maximum valid values for each of the version parts
    #
    MAJOR_MAX = 0xff             # 8 bits
    MINOR_MAX = 0xf              # 4 bits
    UPDATE_MAX = 0xf             # 4 bits
    LOWORDERWINVER_MAX = 0xffff  # 16 bits
    BUILD_MAX = 0x3fff           # 14 bits
    ALPHA_VERSION_NUM = 0x4000   # 16384

    #
    # The phase letters that are valid
    #
    VALID_PHASES = ['d', 'a', 'b', 'f']
    VALID_PHASES_STR = "'d', 'a', 'b' or 'f'"

    def __init__(self, verstr='1.0.0.0-0+d0'):
        """
        The constructor for the Version class.

        Accepts a version string to create the version object from.
        """
        self._major = 0
        self._minor = 0
        self._update = 0
        self._loworderwinver = 0
        self._phase = self.VALID_PHASES[0]
        self._build = 0
        self._parse(str(verstr))

    def get_major(self):
        return self._major

    def set_major(self, major):
        errstr = 'Major version number %d cannot be greater than %d.'
        if major > self.MAJOR_MAX:
            raise VersionError(errstr % (major, self.MAJOR_MAX))
        self._major = major

    def inc_major(self):
        self.set_major(self._major + 1)

    def get_minor(self):
        return self._minor

    def set_minor(self, minor):
        errstr = 'Minor version number %d cannot be greater than %d.'
        if minor > self.MINOR_MAX:
            raise VersionError(errstr % (minor, self.MINOR_MAX))
        self._minor = minor

    def inc_minor(self):
        self.set_minor(self._minor + 1)

    def get_update(self):
        return self._update

    def set_update(self, update):
        errstr = 'Update version number %d cannot be greater than %d.'
        if update > self.UPDATE_MAX:
            raise VersionError(errstr % (update, self.UPDATE_MAX))
        self._update = update

    def inc_update(self):
        self.set_update(self._update + 1)

    def get_loworderwinver(self):
        return self._loworderwinver

    def set_loworderwinver(self, loworderwinver):
        errstr = 'lowOrderWindowsVersion number %d cannot be greater than %d.'
        if loworderwinver > self.LOWORDERWINVER_MAX:
            raise VersionError(errstr % (loworderwinver, self.LOWORDERWINVER_MAX))
        self._loworderwinver = loworderwinver
        self._phase = self.VALID_PHASES[loworderwinver / self.ALPHA_VERSION_NUM]
        self._build = loworderwinver % self.ALPHA_VERSION_NUM

    def inc_loworderwinver(self):
        self.set_loworderwinver(self._loworderwinver + 1)

    def get_phase(self):
        return self._phase

    def set_phase(self, phase):
        phase = phase.lower()
        if phase not in self.VALID_PHASES:
            errstr = "The phase '%s' is not valid. Please use %s."
            raise VersionError(errstr % (phase, self.VALID_PHASES_STR))
        self._phase = phase
        self._loworderwinver = self.VALID_PHASES.index(phase) * self.ALPHA_VERSION_NUM + self._build

    def inc_phase(self):
        if self._phase == self.VALID_PHASES[-1]:
            raise VersionError('Cannot increment phase beyond \'%s\'.' %
                               self.VALID_PHASES[-1])
        self._phase = self.VALID_PHASES[self.VALID_PHASES.index(self._phase) + 1]

    def get_build(self):
        return self._build

    def set_build(self, build):
        errstr = 'Build version number %d cannot be greater than %d.'
        if build > self.BUILD_MAX:
            raise VersionError(errstr % (build, self.BUILD_MAX))
        self._build = build
        self._loworderwinver = self.VALID_PHASES.index(self._phase) * self.ALPHA_VERSION_NUM + build

    def inc_build(self):
        self.set_build(self._build + 1)

    def _parse(self, verstr):
        """
        Internal method to parse a version string.
        """
        ver_pat = re.compile(r'^(\d+)\.(\d+)\.(\d+).(\d+)-0\+([dabf])(\d+)$')
        mat = ver_pat.match(verstr)

        # Error if we were unable to parse the string
        if mat is None:
            errstr = "Error parsing version string '%s'. " + \
                     "Please use the format '1.2.3.4-0+d5'."
            raise VersionError(errstr % (verstr,))

        # Grab the values from the version string
        major = int(mat.group(1))
        minor = int(mat.group(2))
        update = int(mat.group(3))
        loworderwinver = int(mat.group(4))
        phase = mat.group(5).lower()
        build = int(mat.group(6))

        # Check that the phase is valid
        if phase not in self.VALID_PHASES:
            errstr = "The phase '%s' is not valid. Please use %s."
            raise VersionError(errstr % (phase, self.VALID_PHASES_STR))

        # Check that the values fall within their ranges
        errstr = '%s version number %d cannot be greater than %d.'
        if major > self.MAJOR_MAX:
            raise VersionError(errstr % ('Major', major, self.MAJOR_MAX))
        if minor > self.MINOR_MAX:
            raise VersionError(errstr % ('Minor', minor, self.MINOR_MAX))
        if loworderwinver > self.LOWORDERWINVER_MAX:
            raise VersionError(errstr % ('LowOrderWindowsVersion', loworderwinver, self.LOWORDERWINVER_MAX))
        if update > self.UPDATE_MAX:
            raise VersionError(errstr % ('Update', update, self.UPDATE_MAX))
        if build > self.BUILD_MAX:
            raise VersionError(errstr % ('Build', build, self.BUILD_MAX))

        # Set the values for the version object
        self._major = major
        self._minor = minor
        self._update = update
        self._loworderwinver = loworderwinver
        self._phase = phase
        self._build = build

    def __str__(self):
        """
        Return the version string.
        """
        return '%d.%d.%d.%d-0+%s%d' % (self._major,
                                       self._minor,
                                       self._update,
                                       self._loworderwinver,
                                       self._phase,
                                       self._build)

    def __repr__(self):
        """
        Return a string representation of the version object.
        """
        return 'PackageVersion(%s)' % repr(str(self))

    def __cmp__(self, other):
        """
        Compare one version to another.
        """
        #
        # If the other thing is not a version object try to make it into one
        #
        try:
            if not isinstance(other, PackageVersion):
                other = PackageVersion(other)
        except VersionError:
            raise VersionError('Unable to compare %s with %s.' % \
                               (repr(self), repr(other)))

        #
        # Compare the versions
        #
        vp = self.VALID_PHASES

        return cmp(self.get_major(), other.get_major()) or \
               cmp(self.get_minor(), other.get_minor()) or \
               cmp(self.get_update(), other.get_update()) or \
               cmp(self.get_loworderwinver(), other.get_loworderwinver()) or \
               cmp(vp.index(self.get_phase()), vp.index(other.get_phase())) or \
               cmp(self.get_build(), other.get_build())

def list_dir(directory, mode="mtime"):
    """Get all subdirectories under given directory, sorted by ctime or mtime
    If mode is mtime, it will be sorted by mtime (this is the default)
    Otherwise it will be sorted by ctime
    Return value will be in format[(ctime/mtime, full_path), ...]
    If the given directory doesn't exist, return an empty list.
    """
    directories = []

    #if the given directory doesn't exist, return an empty list.
    if not os.path.isdir(directory):
        return directories

    if mode == "mtime":
        directories = [(os.path.getmtime(
                os.path.join(directory, tmp)),
              os.path.join(directory, tmp))
                for tmp in os.listdir(directory)
                    if (not tmp.startswith(".") and
                        os.path.isdir(os.path.join(directory, tmp)))
            ]
    else:
        directories = [(os.path.getctime(
                os.path.join(directory, tmp)),
              os.path.join(directory, tmp))
                for tmp in os.listdir(directory)
                    if (not tmp.startswith(".") and
                        os.path.isdir(os.path.join(directory, tmp)))
            ]
    directories.sort()
    directories.reverse()
    return directories


def get_latest_verified_installer(base_path):
    """Get the latest installer folder under the given base path
    If the given base_path could not be found, it will return None
    """
    latest_installer = ""
    if os.path.isdir(base_path):
        try:
            folder_list = list_dir(base_path)
            for (_, path) in folder_list:
                if os.path.exists(os.path.join(path,"verified")):
                    return path
            else:
                return None
        except:
            print(
                "Could not find out the latest installer from <%s>." %
                base_path)
            return None
    else:
        print("%s is an invalid path." % base_path)
        return None

def to_int_list(s):
    return map(int, s.split('.'))

def get_sorted_version_folders(directory):
    subdirs = [subdir
                   for subdir in os.listdir(directory)
                   if (not subdir.startswith(".") and
                       os.path.isdir(os.path.join(directory, subdir)))
                   ]
    sorted_subdirs = sorted(subdirs, key=to_int_list)
    sorted_subdirs.reverse()
    sorted_directories = [os.path.join(directory, subdir) for subdir in sorted_subdirs]
    return sorted_directories

def execSysCmd(command, delay=0):
    ret = os.system(command)
    time.sleep(delay)
    return ret if ret not in ignoredErrCode else 0

def get_latest_nipkg(base_path):
    """Get the latest nipkg folder under the given base path
    If the given base_path could not be found, it will return None
    """
    latest_nipkg = "1.0.0.0-0+d0"
    if 'http://' in base_path or 'https://' in base_path:
        try:
            base_path = base_path if base_path.endswith('/') else (base_path + '/')
            matchedURL = [latest_nipkg]
            dir_pat = re.compile(r'<A HREF="(.+?)">')
            ver_pat = re.compile(r'(\d+)\.(\d+)\.(\d+).(\d+)-0\+([dabf])(\d+)')
            req = urllib2.Request(base_path)
            content = urllib2.urlopen(req).read()
            for line in content.split('\r\n'):
                for item in dir_pat.finditer(line):
                    if ver_pat.search(item.group(1)) is not None and \
                        PackageVersion(os.path.basename(item.group(1)[:-1])) > PackageVersion(matchedURL[0]):
                        matchedURL[0] = os.path.basename(item.group(1)[:-1])
            latest_nipkg = urlparse.urljoin(base_path, matchedURL[0] + '/')
        except:
            return None
    else:
        if os.path.isdir(base_path):
            try:
                base_path = base_path[:-1] if base_path.endswith('\\') else base_path
                for dir in os.listdir(base_path):
                    if os.path.isdir(os.path.join(base_path, dir)) \
                        and PackageVersion(dir) > PackageVersion(latest_nipkg):
                        latest_nipkg = dir
                latest_nipkg = os.path.join(base_path, latest_nipkg)
            except:
                return None
        else:
            return None
    return latest_nipkg


def storeURLContent(urlPath, localPath):
    request = urllib2.Request(urlPath)
    urllib2.urlopen(request)
    if not os.path.exists(os.path.dirname(localPath)):
        os.makedirs(os.path.dirname(localPath))
    urllib.urlretrieve(urlPath, localPath)


def parseInputCmdParams(argv):
    parser = optparse.OptionParser(usage=os.path.basename(__file__)+' [options]',
                                    formatter=optparse.TitledHelpFormatter(width=75))
    parser.add_option("-l", "--latest", action="store_true", dest="findlatest", default=False, help="choose the latest built installer")
    parser.add_option("-p", "--path", action="store", type='string', help="the path to the installer, example: \\\\us-aus-argo\\ni\\nipkg\\feeds\\ni-l\\ni-labview-2019\\19.0.0")
    parser.add_option("-a", "--addRepoOnly", action="store_true", dest="addRepoOnly", default=False, help="only add feed to NI Package Manager and skip installing it")
    settings, args = parser.parse_args(argv)
    return settings


def getTopLevelPackages(repoPath):
    """
    Retrieve the top level package names from the given repo path
    """
    isUrlPath = False
    topPkgs = []

    if 'http://' in repoPath or 'https://' in repoPath:
        isUrlPath = True
        repoPath = repoPath if repoPath.endswith('/') else (repoPath + '/')
        workingDir = os.path.join(os.getcwd(), 'URLTemp')
        if not os.path.exists(workingDir):
            os.mkdir(workingDir)
        try:
            ### Check if the URL is valid
            storeURLContent(urlparse.urljoin(repoPath, 'meta-data/Feed_Tree.xml'),
                                             os.path.join(workingDir, 'meta-data', 'Feed_Tree.xml'))
            repoPath = workingDir
        except (IOError, urllib.ContentTooShortError, urllib2.URLError):
            raise Exception('INET_E_INVALID_URL')

    if os.path.exists(os.path.join(repoPath, 'meta-data', 'Feed_Tree.xml')):
        coreFilePath = os.path.join(repoPath, 'meta-data', 'Feed_Tree.xml')
    else:
        raise Exception('ERROR_FILE_NOT_FOUND')

    tree = xml.etree.ElementTree.parse(coreFilePath)
    for child in tree.getroot().findall('package'):
        topPkgs.append(child.attrib['name'])
    if isUrlPath is True:
        os.remove(coreFilePath)
    return topPkgs


def getSetupPath(directory):
    for r, dir, fileLst in os.walk(directory):
        for f in fileLst:
            if f.lower() == "setup.exe" or f.lower() == "install.exe":
                return os.path.join(r,f)
                #relativePath = os.path.relpath(r, directory)
                #if "win64U" in relativePath and "msvc" in relativePath:
                    #return os.path.join(relativePath, f)
    else:
        raise Exception()


def installPackageManager(installerDir):
    ### define ERROR_FILE_NOT_FOUND 2L in WinError.h
    ### The system cannot find the file specified.

    ret_val = 0
    verFolderList = get_sorted_version_folders(installerDir)
    if not verFolderList:
        return WINERRORS['ERROR_FILE_NOT_FOUND']
    else:
        for subdir in verFolderList:
            installer_path = get_latest_verified_installer(subdir)
            if not installer_path:
                continue
            else:
                break
        else:
            return WINERRORS['ERROR_FILE_NOT_FOUND']
        try:
            latestPath = "\""+getSetupPath(installer_path)+"\""
            print "*| GetLatestInstaller:" + latestPath + " |*"
            ret_val = execSysCmd("%s --passive --accept-eulas" % latestPath, 60)
        except Exception:
            print(NIPackageManagerDefaultInstallerPath)
            ret_val = execSysCmd("%s /Q" % NIPackageManagerDefaultInstallerPath, 60)
        finally:
            execSysCmd("TASKKILL /F /IM %s /T" % NIPackageManagerProcessName)
            return ret_val


def installProduct(productPath, addRepoOnly=False):
    """
    Install the specified product
    If the way of 'Custom Package' is specified, it will install with the given package directly
    if the way of 'Custom Repo' or 'NI Hub', it will parse the top level package at first
    """
    if productPath is None:
        return WINERRORS['ERROR_PATH_NOT_FOUND']

    cmd_list = []
    ret_val = 0
    productPath = productPath.strip()
    try:
        nipkg_regkey = _winreg.OpenKey(_winreg.HKEY_LOCAL_MACHINE,
                                       r'SOFTWARE\National Instruments\NI Package Manager\CurrentVersion')
    except:
        ret_val = installPackageManager(NIPackageManagerInstallerDir)
        if ret_val:
            return ret_val
        else:
            nipkg_regkey = _winreg.OpenKey(_winreg.HKEY_LOCAL_MACHINE,
                                           r'SOFTWARE\National Instruments\NI Package Manager\CurrentVersion')

    nipkg_path = '"' + os.path.join(_winreg.QueryValueEx(nipkg_regkey, 'Path')[0], 'nipkg.exe') + '"'
    NIPackageManager_path = '"' + os.path.join(_winreg.QueryValueEx(nipkg_regkey, 'Path')[0], 'NIPackageManager.exe') + '"'
    install_flag = r'ni-certificates --progress-only --accept-eulas --prevent-reboot'

    try:
        if productPath.endswith('.nipkg'):
            # Install package directly
            cmd_line = ' '.join([nipkg_path, install_flag, productPath])
            cmd_list.append(cmd_line)
        else:
            # Add repo
            cmd_line = ' '.join([nipkg_path, 'repo-add', productPath])
            cmd_list.append(cmd_line)
            # Update package
            cmd_line = ' '.join([nipkg_path, 'update'])
            cmd_list.append(cmd_line)
            if not addRepoOnly:
                # # Install package
                for topPkg in getTopLevelPackages(productPath):
                    cmd_line = ' '.join([NIPackageManager_path, 'install', topPkg, install_flag])
                    cmd_list.append(cmd_line)
        print cmd_list
        for cmd in cmd_list:
            ret_val = execSysCmd(cmd)
            if ret_val:
                break
    except Exception, errinfo:
        ret_val = WINERRORS[errinfo.message]
    return ret_val


if __name__ == '__main__':
    """Install the NextGen product based on the given path (repo/package installed)"""
    if len(sys.argv) > 5 or (len(sys.argv) < 3 and sys.argv[1]!="-h" and sys.argv[1]!="--help"):
        ### define ERROR_INVALID_PARAMETER 87L in WinError.h
        sys.exit(WINERRORS['ERROR_INVALID_PARAMETER'])

    settings = parseInputCmdParams(sys.argv)
    if settings.findlatest is False:
        productPath = settings.path.strip()
    else:
        productPath = get_latest_nipkg(settings.path.strip())
    print "*| GetLatestInstaller:" + productPath + " |*"
    ret_val = installProduct(productPath, settings.addRepoOnly)
    print "install return code:", ret_val
    sys.exit(ret_val)
