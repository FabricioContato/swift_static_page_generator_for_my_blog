import Foundation

let passedArguments = CommandLine.arguments

let exePath = CommandLine.arguments[0]
let exeURL = URL(fileURLWithPath: exePath).standardized
let exeDirectory = exeURL.deletingLastPathComponent()

var userFileName = "text.txt"
//var outputFileName = "output.html"
let userIdentation = 1

if passedArguments.count >= 2{
    userFileName = passedArguments[1]
}

//if passedArguments.count >= 3{
//    outputFileName = passedArguments[2]
//}

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

populateTagValuesDict()


// plain file
//let userContent = try String(contentsOfFile: "\(exeDirectory.path)/\(userFileName)")
//var tagLines = userContent.split(separator: "\n")


let finalStringAndOutputFileName = buildFinalString(targetPath: exeDirectory.path, txtFileName: userFileName)
let finalString = finalStringAndOutputFileName.finalString
let outputFileName = finalStringAndOutputFileName.outputFileName


do {
    let url = URL(fileURLWithPath: "\(exeDirectory.path)/\(outputFileName)")
    try finalString.write(to: url, atomically: true, encoding: String.Encoding.utf8)
} catch {
    print("erro")
}

print(finalString)