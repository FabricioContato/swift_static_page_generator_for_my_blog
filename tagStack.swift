

var tagStack: [TagSettings] = []
var finalString: String = ""

enum initial_or_end {
    case initial
    case end
}

func getConversion(tagSettings: TagSettings, position :initial_or_end) -> String {
    
    let identation = TagSettings.identation

    var text = TagSettings.text ?? ""

    let tag = TagSettings.tag

    if position == .initial {
        guard let initalValue = TagSettings.initial else {return ""}

        return String(repeating:" ", count: identation) + initalValue + text
    }else
    {
        guard let endValue = TagSettings.end else {return ""}

        return String(repeating:" ", count: identation) + endValue
    }
}

func addToFinalString(tagSettings: TagSettings, position :initial_or_end) -> Void{
    finalString += getConversion(tagSettings: tagSettings, position: position) + "\n"
}

func tagstackAppendTagSettings(tagSettingsArry: [TagSettings]) -> Void{

    for tagSettinsg in tagSettingsArry{
    
        while true {

            if tagStack.isEmpty {
                //let tagSettings = TagSettings(identation: identation!, text: text, tag: tag!)
                addToFinalString(tagSettings: tagSettings, position: .initial)
                tagStack.append(tagInfo)
                break
            }
            else
            if tagStack[tagStack.count - 1].identation < tagSettinsg.identation {
                //let tagInfo = (identation: identation!, text: text, tag: tag!)
                addToFinalString(tagInfo: tagInfo, position: .initial)
                tagStack.append(tagInfo)
                break
            }
            else{
                let removedTagSettings = tagStack.removeLast()
                addToFinalString(tagSettings: removedTagSettings, position: .end)
                //print(addToFinalString(tagInfo: removedtagInfo, position: .end))
            }
        }
    }
}

func unStackRemaining() -> Void{
    for _ in tagStack {
        let removedTagSettings = tagStack.removeLast()
        addToFinalString(tagSettings: removedTagSettings, position: .end)
    }
}