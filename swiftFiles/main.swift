import Foundation

let passedArguments = CommandLine.arguments

let exePath = CommandLine.arguments[0]
let exeURL = URL(fileURLWithPath: exePath).standardized
let exeDirectory = exeURL.deletingLastPathComponent()

var userFileName = "text.txt"
var outputFileName = "output.html"
let userIdentation = 1

if passedArguments.count >= 2{
    userFileName = passedArguments[1]
}

if passedArguments.count >= 3{
    outputFileName = passedArguments[2]
}

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
let userContent = try String(contentsOfFile: "\(exeDirectory.path)/\(userFileName)")
let tagLines = userContent.split(separator: "\n")

var identation: Int? = nil
var tag: String? = nil

// adding the default top-level tag #html
var tagHtmlSettingsArry = getTagSettingsArryByTag(tag: "#html")
tagHtmlSettingsArry[0].setIdentation(newIdentation:0)
tagstackAppendTagSettings(tagSettingsArry:tagHtmlSettingsArry)

// adding the user tags
for str in tagLines{
    guard let indexOfHashtag = str.firstIndex(of: "#") else{
        continue
    }

    var tagEndIndex = str.endIndex
    var text: String? = nil
    if let indexOftextSpace = str[indexOfHashtag...].firstIndex(of: " "){
        tagEndIndex = indexOftextSpace
        let indexOftextStart = str.index(indexOftextSpace, offsetBy: 1, limitedBy: str.endIndex) ?? indexOftextSpace
        text = String(str[indexOftextStart...])
    }

    identation = str.distance(from: str.startIndex, to: indexOfHashtag) + 1
    tag = String(str[indexOfHashtag..<tagEndIndex])

    var tagSettingsArry = getTagSettingsArryByTag(tag: tag!)
    tagSettingsArry[0].setIdentation(newIdentation:identation!)


    if tagSettingsArry.count == 2 {
        tagSettingsArry[1].setText(newText:text?.escapedHTML ?? "")
        tagSettingsArry[1].setIdentation(newIdentation:identation! + userIdentation)
    }else {
        tagSettingsArry[0].setText(newText:text?.escapedHTML ?? "")
    }

    tagstackAppendTagSettings(tagSettingsArry:tagSettingsArry)

}

unStackRemaining()

do {
    let url = URL(fileURLWithPath: "\(exeDirectory.path)/\(outputFileName)")
    try finalString.write(to: url, atomically: true, encoding: String.Encoding.utf8)
} catch {
    print("erro")
}

print(finalString)