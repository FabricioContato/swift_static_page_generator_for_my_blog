

var tagStack: [TagSettings] = []

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

func addToFinalString(finalString: inout String, tagSettings: TagSettings, position :initial_or_end) -> Void{
    finalString += getConversion(tagSettings: tagSettings, position: position)
}

func tagstackAppendTagSettings(finalString: inout String , tagSettingsArry: [TagSettings]) -> Void{

    for tagSettings in tagSettingsArry{
    
        while true {

            if tagStack.isEmpty {
                addToFinalString(finalString: &finalString ,tagSettings: tagSettings, position: .initial)
                tagStack.append(tagSettings)
                break
            }
            else
            if tagStack[tagStack.count - 1].identation < tagSettings.identation {
                addToFinalString(finalString: &finalString ,tagSettings: tagSettings, position: .initial)
                tagStack.append(tagSettings)
                break
            }
            else{
                let removedTagSettings = tagStack.removeLast()
                addToFinalString(finalString: &finalString ,tagSettings: removedTagSettings, position: .end)
            }
        }
    }
}

func unStackRemaining(finalString: inout String) -> Void{
    for _ in tagStack {
        let removedTagSettings = tagStack.removeLast()
        addToFinalString(finalString: &finalString, tagSettings: removedTagSettings, position: .end)
    }
}