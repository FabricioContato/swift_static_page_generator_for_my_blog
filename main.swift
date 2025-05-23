import Foundation

let ruleContent = try String(contentsOfFile: "/code/tagRules.txt")
let ruleParts = ruleContent.split(separator: "\n%---%\n")

var tagValuesDict: [String: (initial: String, text: String?, end: String)] = [:]
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

    tagValuesDict[tag] = (initial: initialRule, text: nil, end: endRule)
    existingTags.append(tag);
    print((tag: tag, initial: initialRule, text:"", end: endRule))

}


let userContent = try String(contentsOfFile: "/code/plain.txt")
let userParts = userContent.split(separator: "\n")

var identation: Int? = nil
var tag: String? = nil
var tagStack: [(identation: Int, text: String?, tag: String)] = []

enum initial_or_end {
    case initial
    case end
}

var finalString: String = ""

func getConversion(tagInfo: (identation: Int, text: String?, tag: String), position :initial_or_end) -> String {
    
    let identation = tagInfo.identation

    let text = tagInfo.text ?? ""

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

func addToFinalString(tagInfo: (identation: Int, text: String?, tag: String), position :initial_or_end) -> Void{
    //print("----------")
    finalString += getConversion(tagInfo: tagInfo, position: position) + "\n"
    //return finalString
}

for str in userParts{
    guard let indexOfHashtag = str.firstIndex(of: "#") else{
        continue
    }

    var tagEndIndex = str.endIndex
    var text: String? = nil
    if let indexOfTextSpace = str[indexOfHashtag...].firstIndex(of: " "){
        tagEndIndex = indexOfTextSpace
        let indexOfTextStart = str.index(indexOfTextSpace, offsetBy: 1, limitedBy: str.endIndex) ?? indexOfTextSpace
        text = String(str[indexOfTextStart...])
    }

    identation = str.distance(from: str.startIndex, to: indexOfHashtag)
    tag = String(str[indexOfHashtag..<tagEndIndex])

    while true {

        //print((identation: identation!, text: text, tag: tag!))

        if tagStack.isEmpty {
            let tagInfo = (identation: identation!, text: text, tag: tag!)
            //print(addToFinalString(tagInfo: tagInfo, position: .initial))
            addToFinalString(tagInfo: tagInfo, position: .initial)
            tagStack.append(tagInfo)
            break
        }
        else
        if tagStack[tagStack.count - 1].identation < identation! {
            let tagInfo = (identation: identation!, text: text, tag: tag!)
            //print(addToFinalString(tagInfo: tagInfo, position: .initial))
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

print("----------")
print(finalString)

do {
    let url = URL(fileURLWithPath: "/code/end.html")
    try finalString.write(to: url, atomically: true, encoding: String.Encoding.utf8)
} catch {
    print("erro")
}
