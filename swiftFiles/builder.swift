func listOfLines(targetPath: String, fileName: String) -> [Substring] {
    var fileContent: String
    do{
        fileContent = try String(contentsOfFile: "\(targetPath)/\(fileName)")
        return fileContent.split(separator: "\n")
    } catch {
        print(" no file \(fileName) Found!")
    }
    return [""]
}

func buildFinalString(targetPath: String, txtFileName: String) -> (finalString: String, outputFileName: String){
    var finalString = ""
    var fileLines = listOfLines(targetPath: targetPath, fileName: txtFileName)
    let outputFileName = String(fileLines.removeFirst() )
    let tagLines = fileLines
    
    // initial tag and identation
    var identation = 0
    var tag = "#html"

    // adding the initial default tag to the stack
    var tagHtmlSettingsArry = getTagSettingsArryByTag(tag: tag)
    tagHtmlSettingsArry[0].setIdentation(newIdentation: identation)
    tagstackAppendTagSettings(finalString: &finalString, tagSettingsArry:tagHtmlSettingsArry)

    // iteration over the lines of the user document, exepct the first that was removed
    for str in tagLines{
        // lines with no tag simble # are ignored
        guard let indexOfHashtag = str.firstIndex(of: "#") else{
            continue
        }

        // Calculating and extrating text, identation and tag name from a line
        var tagEndIndex = str.endIndex
        var text: String? = nil
        if let indexOftextSpace = str[indexOfHashtag...].firstIndex(of: " "){
            tagEndIndex = indexOftextSpace
            let indexOftextStart = str.index(indexOftextSpace, offsetBy: 1, limitedBy: str.endIndex) ?? indexOftextSpace
            text = String(str[indexOftextStart...])
        }
        identation = str.distance(from: str.startIndex, to: indexOfHashtag) + 1
        tag = String(str[indexOfHashtag..<tagEndIndex])

        // Getting tag information (like initial, end, related tags) in the form of a new TagSettings object
        var tagSettingsArry = getTagSettingsArryByTag(tag: tag)

        // setting the identation of the new TagSettings object
        tagSettingsArry[0].setIdentation(newIdentation:identation)

        // if a related tag is present, it should cary the text
        if tagSettingsArry.count == 2 {
            tagSettingsArry[1].setText(newText:text?.escapedHTML ?? "")
            tagSettingsArry[1].setIdentation(newIdentation:identation + userIdentationPattern)
        }else {
            tagSettingsArry[0].setText(newText:text?.escapedHTML ?? "")
        }

        // stacking the new TagSettings object and passing finalString for string increments
        tagstackAppendTagSettings(finalString: &finalString, tagSettingsArry:tagSettingsArry)

    }

    // unstacking remaining TagSettings object and passing finalString for string increments
    unStackRemaining(finalString: &finalString)

    return (finalString: finalString, outputFileName: outputFileName)
}

func buildFinalStringsArry(targetPath: String, fileNameArry: [String]) -> [(finalString: String, outputFileName: String)] {
    var finalStringAndoutputFileNameArry: [(finalString: String, outputFileName: String)] = []
    
    for txtFileName: String in fileNameArry{
        let finalStringAndoutputFileName: (finalString: String, outputFileName: String) =  buildFinalString(targetPath: targetPath, txtFileName: txtFileName)
        finalStringAndoutputFileNameArry.append(finalStringAndoutputFileName)
    }

    return finalStringAndoutputFileNameArry
}