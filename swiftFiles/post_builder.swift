import Foundation

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

//print("<user-file-name> <output-file-name> <identations>")
//let userInputs = readLine()!.split(separator: " ")

//let userFileName = userInputs[0]
//let outputFileName = userInputs[1]
//let userIdentation = Int(String(userInputs[2])) ?? 1

let userFileName = "text2.txt"
let outputFileName = "output.html"
let userIdentation = 2

// plain file
let userContent = try String(contentsOfFile: "/code/\(userFileName)")
let tagLines = userContent.split(separator: "\n")

var identation: Int? = nil
var tag: String? = nil



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

    identation = str.distance(from: str.startIndex, to: indexOfHashtag)
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
    let url = URL(fileURLWithPath: "/code/\(outputFileName)")
    try finalString.write(to: url, atomically: true, encoding: String.Encoding.utf8)
} catch {
    print("erro")
}

print(finalString)