

var tagStack: [TagSettings] = []
var finalString: String = ""

enum initial_or_end {
    case initial
    case end
}

func getConversion(tagSettings: TagSettings, position :initial_or_end) -> String {
    
    let identation = tagSettings.identation

    let text = tagSettings.text ?? ""
    

    if position == .initial {
        let initalValue = tagSettings.initial

        if "#<" == tagSettings.tag{
            return initalValue + text
        }

        return String(repeating:" ", count: identation) + initalValue + text
    }else
    {
        let endValue = tagSettings.end
        return String(repeating:" ", count: identation) + endValue
    }
}

func addToFinalString(tagSettings: TagSettings, position :initial_or_end) -> Void{
    finalString += getConversion(tagSettings: tagSettings, position: position)
}

func tagstackAppendTagSettings(tagSettingsArry: [TagSettings]) -> Void{

    for tagSettings in tagSettingsArry{
    
        while true {

            if tagStack.isEmpty {
                //let tagSettings = TagSettings(identation: identation!, text: text, tag: tag!)
                addToFinalString(tagSettings: tagSettings, position: .initial)
                tagStack.append(tagSettings)
                break
            }
            else
            if tagStack[tagStack.count - 1].identation < tagSettings.identation {
                //let tagInfo = (identation: identation!, text: text, tag: tag!)
                addToFinalString(tagSettings: tagSettings, position: .initial)
                tagStack.append(tagSettings)
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