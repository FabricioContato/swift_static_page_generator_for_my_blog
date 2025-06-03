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

    var tagHtmlSettingsArry = getTagSettingsArryByTag(tag: tag)
    tagHtmlSettingsArry[0].setIdentation(newIdentation: identation)
    tagstackAppendTagSettings(finalString: &finalString, tagSettingsArry:tagHtmlSettingsArry)

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

        var tagSettingsArry = getTagSettingsArryByTag(tag: tag)
        tagSettingsArry[0].setIdentation(newIdentation:identation)


        if tagSettingsArry.count == 2 {
            tagSettingsArry[1].setText(newText:text?.escapedHTML ?? "")
            tagSettingsArry[1].setIdentation(newIdentation:identation + userIdentation)
        }else {
            tagSettingsArry[0].setText(newText:text?.escapedHTML ?? "")
        }

        tagstackAppendTagSettings(finalString: &finalString, tagSettingsArry:tagSettingsArry)

    }

    unStackRemaining(finalString: &finalString)

    return (finalString: finalString, outputFileName: outputFileName)
}