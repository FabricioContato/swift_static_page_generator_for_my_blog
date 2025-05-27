import Foundation

print("<tag-file-name> <text-file-name> <output-file-name>")
let userInputs = readLine()!.split(separator: " ")

let tagFileName = userInputs[0]
let textFileName = userInputs[1]
let outputFileName = userInputs[2]



let ruleContent = try String(contentsOfFile: "/code/tagRules.txt")
let ruleParts = ruleContent.split(separator: "\n%---%\n")

var tagValuesDict: [String: (initial: String, placeHolder: String?, end: String)] = [:]
var existingTags: [String] = []

for tagSet in ruleParts{

    //let tagStartIndex = tagSet.firstIndex
    let tagFinalIndex = tagSet.range(of: "\ninitial\n")!.lowerBound
    let tag = String(tagSet[..<tagFinalIndex])
    

    let initialRuleStartIndex = tagSet.index(tagSet.range(of: "initial\n")!.lowerBound, offsetBy: 8, limitedBy: tagSet.endIndex)!
    let initialRulefinalIndex = tagSet.range(of: "\nend\n")!.lowerBound

    let initialRule = String(tagSet[initialRuleStartIndex..<initialRulefinalIndex])

    let endRuleStartIndex = tagSet.index(tagSet.range(of: "end\n")!.lowerBound, offsetBy: 4, limitedBy: tagSet.endIndex)!
    let endRuleFinalIndex = tagSet.endIndex

    let endRule = String(tagSet[endRuleStartIndex..<endRuleFinalIndex])

    tagValuesDict[tag] = (initial: initialRule, placeHolder: nil, end: endRule)
    existingTags.append(tag);
    //print((tag: tag, initial: initialRule, placeHolder:"", end: endRule))

}


// text file
let textContent = try String(contentsOfFile: "/code/\(textFileName)")
var textParts = textContent.split(separator: "\n")
print(textParts)

// plain file
let tagsContent = try String(contentsOfFile: "/code/\(tagFileName)")
let tagsParts = tagsContent.split(separator: "\n")

var identation: Int? = nil
var tag: String? = nil
var tagStack: [(identation: Int, placeHolder: String?, tag: String)] = []

enum initial_or_end {
    case initial
    case end
}

var finalString: String = ""

func getConversion(tagInfo: (identation: Int, placeHolder: String?, tag: String), position :initial_or_end) -> String {
    
    let identation = tagInfo.identation

    var text = ""
    if let placeHolder = tagInfo.placeHolder, position == .initial {
        text = placeHolder == "{text}" ? String(textParts.removeFirst()) : ""
    } 
    

    let tag = tagInfo.tag

    if position == .initial {
        guard let initalValue = tagValuesDict[tag]?.initial else {return ""}

        return String(repeating:" ", count: identation) + initalValue + text
    }else
    {
        guard let endValue = tagValuesDict[tag]?.end else {return ""}

        return String(repeating:" ", count: identation) + endValue
    }
}

func addToFinalString(tagInfo: (identation: Int, placeHolder: String?, tag: String), position :initial_or_end) -> Void{
    //print("----------")
    finalString += getConversion(tagInfo: tagInfo, position: position) + "\n"
}

for str in tagsParts{
    guard let indexOfHashtag = str.firstIndex(of: "#") else{
        continue
    }

    var tagEndIndex = str.endIndex
    var placeHolder: String? = nil
    if let indexOfPlaceHolderSpace = str[indexOfHashtag...].firstIndex(of: " "){
        tagEndIndex = indexOfPlaceHolderSpace
        let indexOfPlaceHolderStart = str.index(indexOfPlaceHolderSpace, offsetBy: 1, limitedBy: str.endIndex) ?? indexOfPlaceHolderSpace
        placeHolder = String(str[indexOfPlaceHolderStart...])
    }

    identation = str.distance(from: str.startIndex, to: indexOfHashtag)
    tag = String(str[indexOfHashtag..<tagEndIndex])

    while true {

        if tagStack.isEmpty {
            let tagInfo = (identation: identation!, placeHolder: placeHolder, tag: tag!)
            addToFinalString(tagInfo: tagInfo, position: .initial)
            tagStack.append(tagInfo)
            break
        }
        else
        if tagStack[tagStack.count - 1].identation < identation! {
            let tagInfo = (identation: identation!, placeHolder: placeHolder, tag: tag!)
            addToFinalString(tagInfo: tagInfo, position: .initial)
            tagStack.append(tagInfo)
            break
        }
        else{
            let removedtagInfo = tagStack.removeLast()
            addToFinalString(tagInfo: removedtagInfo, position: .end)
            //print(addToFinalString(tagInfo: removedtagInfo, position: .end))
        }
    }

}

for _ in tagStack{
    let removedtagInfo = tagStack.removeLast()
    addToFinalString(tagInfo: removedtagInfo, position: .end)
    //print(addToFinalString(tagInfo: removedtagInfo, position: .end))
}

//print("----------")
//print(finalString)

do {
    let url = URL(fileURLWithPath: "/code/\(outputFileName)")
    try finalString.write(to: url, atomically: true, encoding: String.Encoding.utf8)
} catch {
    print("erro")
}

print(finalString)