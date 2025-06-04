import Foundation

// get user arguments
let passedArguments = CommandLine.arguments

// get program call context
//let programCall = CommandLine.arguments[0]
var targetPath: String = URL(fileURLWithPath: ".").standardized.path
var outputPath: String = URL(fileURLWithPath: ".").standardized.path

// default values
var fileNameArry: [String] = ["text.txt"]
let userIdentationPattern = 1

//
func getTxtFileNames(in folderURL: String) -> [String] {
    let allItems: [String]
    let txtFiles: [String]
    
    do {
        allItems = try FileManager.default.contentsOfDirectory(atPath: folderURL)
    } catch {
        print("Folder \(folderURL) does not exist")
        exit(1)
    }

    txtFiles = allItems.filter { $0.hasSuffix(".txt") }

    guard txtFiles.count > 0 else { 
        print("No .txt file was found inside folder \(folderURL)")
        exit(1)
    }

    return txtFiles

}

// Function to find out if a path is a folder or not
func isFolder(at url: URL) -> Bool {
    var isDirectory: ObjCBool = false
    let exists = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
}

func isFile(at url: URL) -> Bool {
    var isDirectory: ObjCBool = false
    let exists = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
    return exists && !isDirectory.boolValue
}

// subscribing default value
if passedArguments.count >= 2{
    let secondArgument = passedArguments[1]
    if isFolder(at: URL(fileURLWithPath: secondArgument)) {
        targetPath = URL(fileURLWithPath: secondArgument).standardized.path
        fileNameArry = getTxtFileNames(in : targetPath)
        
    }
    else if isFile(at: URL(fileURLWithPath: secondArgument)){
        fileNameArry = [secondArgument]
    }
    else{
        print("Argument \(secondArgument) is neither a folder not a file!")
        exit(1)
    }

    if passedArguments.count >= 3 {
        let thirdAgument: String = passedArguments[2]
        if isFolder(at: URL(fileURLWithPath: thirdAgument)) {
            outputPath = URL(fileURLWithPath: thirdAgument).standardized.path
        }else{
            print("Argument \(thirdAgument) is not a folder")
            exit(1)
        }

    }
}

// html tag scaping extension
extension String {
    var escapedHTML: String {
        var result = self
        let htmlEscapes: [String: String] = [
            "<": "&lt;",
            ">": "&gt;"
        ]
        for (char, escape) in htmlEscapes {
            result = result.replacingOccurrences(of: char, with: escape)
        }
        return result
    }
}

// output file writing function
func writeOutputFile(outputPath: String, outputFileName: String, finalString: String){
    do {
        let url = URL(fileURLWithPath: "\(outputPath)/\(outputFileName)")
        try finalString.write(to: url, atomically: true, encoding: String.Encoding.utf8)
    } catch {
        print("I could not write file \(outputFileName) on folder \(outputPath)")
        exit(1)
    }

}


// initiate the tag dictionary
populateTagValuesDict(targetPath: targetPath)


for (index, aux) in buildFinalStringsArry(targetPath: targetPath, fileNameArry: fileNameArry).enumerated() {
    writeOutputFile(outputPath: outputPath, outputFileName: aux.outputFileName, finalString: aux.finalString)
    print("convertion of \(fileNameArry[index]) into \(aux.outputFileName) is done!")
}

print("All convertions are done!")