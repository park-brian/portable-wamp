
// latest versions, download links, and target directories to extract
var resources = {
    httpd: {
        version: '2.4.43',
        url: 'http://www.apachehaus.com/downloads/httpd-2.4.43-o111f-x64-vc15.zip',
        subfolder: 'Apache24',
        sha256: '1bc0710222859ae84956753bd1f4ee0a49e503ce70bf2f6deb82d8f9f3dd81be'
    },
    mysql: {
        version: '8.0.20',
        url: 'https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.20-winx64.zip',
        subfolder: 'mysql-8.0.20-winx64',
        sha256: 'b9a7592ac170a6c55ce4f20c16e120c789d3d89342ea5681362311e118103a8a'
    },
    php: {
        version: '7.4.6',
        url: 'https://windows.php.net/downloads/releases/archives/php-7.4.6-Win32-vc15-x64.zip',
        sha256: '4ea958b8b0a537e930cde8b8a10e5ec2664028f995c391439ba294bd8695119a'
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

    WScript.Echo("Setup is complete. Please set a password for the MySQL root user after logging in.\n");
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

/*

function getAbsolutePath(path) {
    return WScript
        .CreateObject('Scripting.FileSystemObject')
        .GetAbsolutePathName(path);
}

function createFolder(path) {
    if (!fileExists(path)) {
        WScript
            .CreateObject('Scripting.FileSystemObject')
            .CreateFolder(path);
    }
}

function deleteFile(path) {
    if (fileExists(path)) {
        WScript
            .CreateObject('Scripting.FileSystemObject')
            .DeleteFile(path);
    }
}*/

/*
function execute(cmd, sync) {
    var shell = WScript.CreateObject('WScript.Shell');
    var exec = shell.Exec(cmd);
    while (sync && exec.Status == 0)
         WScript.Sleep(100);
    return {
        status: exec.Status,
        stdout: exec.StdOut.ReadAll(),
        stderr: exec.StdErr.ReadAll()
    };
}

function fileExists(path) {
    var fileSystem = WScript.CreateObject('Scripting.FileSystemObject');
    return fileSystem.FileExists(path) || fileSystem.FolderExists(path);
}

function formatString(string, data) {
    return string.replace(/{[^{}]+}/g, function(match) {
        return data[match.replace(/[{}]/g, '')] || '';
    });
}
*/

/*
function getFileHash(filepath, hashType) {
    var cmd = formatString('CertUtil -hashfile "{filepath}" "{hashType}"', {
        filepath: filepath,
        hashType: hashType || 'SHA256' // default hash type
    });
    var output = execute(cmd).stdout;
    if (/failed/i.test(output))
        throw(output);
    return output.split('\n')[1];
}
*/