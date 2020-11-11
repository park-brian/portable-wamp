
// latest versions, download links, and target directories to extract
var resources = {
    httpd: {
        version: '2.4.46',
        url: 'https://www.apachehaus.com/downloads/httpd-2.4.46-o111g-x64-vc15.zip',
        subfolder: 'Apache24'
    },
    mysql: {
        version: '8.0.22',
        url: 'https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.22-winx64.zip',
        subfolder: 'mysql-8.0.22-winx64'
    },
    php: {
        version: '7.4.11',
        url: 'https://windows.php.net/downloads/releases/archives/php-7.4.11-Win32-vc15-x64.zip'
    }
};

try {
   main();
} catch(e) {
    WScript.Echo('ERROR: ' + e);
    for (var key in e) {
        WScript.Echo(key + ": " + e[key])
    }
} finally {
    WScript.Quit(0);
}

function main() {
    var fileSystem = WScript.CreateObject('Scripting.FileSystemObject');
    var shell = WScript.CreateObject('WScript.Shell');

    for (var resourceName in resources) {
        var resource = resources[resourceName];
        var filename = resource.url.split('/').pop();
        var archivePath = fileSystem.GetAbsolutePathName('environment\\archive\\' + filename);
        var configPath = fileSystem.GetAbsolutePathName('default-configuration\\' + resourceName);
        var targetPath = fileSystem.GetAbsolutePathName('environment\\' + resourceName);

        // download and extract resources to their respective directories
        if (!fileSystem.FileExists(archivePath)) {
            WScript.Echo("Downloading " + resource.url);
            downloadFile(resource.url, archivePath);
        }

        // extract the specified directory within each resource to the target path
        WScript.Echo("Extracting " + archivePath + " to " + targetPath);
        copyFiles(archivePath, targetPath, {subfolder: resource.subfolder});

        // copy configuration to the target path
        WScript.Echo("Copying configuration to " + targetPath + "\n");
        copyFiles(configPath, targetPath);
    }

    // initialize mysql
    WScript.Echo("Initializing MySQL\n");
    shell.Exec('.\\environment\\mysql\\bin\\mysqld.exe --default-authentication-plugin=mysql_native_password --initialize-insecure');

    // download composer
    WScript.Echo("Downloading Composer\n");
    downloadFile('https://getcomposer.org/composer-stable.phar', 'environment\\bin\\composer.php');

    WScript.Echo("Setup is complete. Please set a password for the MySQL root user.\n");
}

/**
 * Copies/extracts the contents of a source folder to a target folder
 * @param {String} source - Absolute path to the source folder
 * @param {String} target - Absolute path to the target folder
 * @param {{subfolder: String}} options - The root directory is often duplicated
 * within archived folders. The subfolder option allows us to specify a subfolder 
 * from which to copy items.
 */
function copyFiles(source, target, options) {
    // Ensure target path exists
    var fileSystem = WScript.CreateObject('Scripting.FileSystemObject')
    if (!fileSystem.FolderExists(target))
        fileSystem.CreateFolder(target);

    // Use Shell.Application instead of Scripting.FileSystemObject to support zip archives
    var shell = WScript.CreateObject('Shell.Application');
    var sourceFolder = shell.NameSpace(source);
    var targetFolder = shell.NameSpace(target);

    // The subfolder option is used to to copy items
    // from a subfolder within a zip archive
    var items = (options && options.subfolder)
        ? sourceFolder.ParseName(options.subfolder).GetFolder.Items()
        : sourceFolder.Items();

    // 4: Do not display a progress dialog box
    // 16: Respond with "Yes to All" for any dialog box that is displayed
    targetFolder.CopyHere(items, 4 | 16);
}

/**
 * Downloads a file to the specified location
 * @param {String} url - URL of resource to download
 * @param {String} filepath - Target filepath for downloaded resource
 */
function downloadFile(url, filepath) {
    var request = WScript.CreateObject('WinHttp.WinHttpRequest.5.1');
    var stream = WScript.CreateObject('ADODB.Stream');

    // send download request
    request.Open('GET', url, true);
    request.Send();
    request.WaitForResponse();

    // write response to file
    stream.Open();
    stream.Type = 1;
    stream.Write(request.ResponseBody);
    stream.Position = 0;
    stream.SaveToFile(filepath, 2);
    stream.Close();
}
