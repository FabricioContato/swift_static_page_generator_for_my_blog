import Foundation

struct TagSettings {
    var tag: String
    var identation: Int = 0
    var initial: String
    var text: String? = nil
    var end: String
    var relatedTags: [String]? = nil

    mutating func setText(newText: String) -> Void {
        text = newText
    }

    mutating func setIdentation(newIdentation: Int) -> Void {
        identation = newIdentation
    }
    
}

var tagValuesDict: [String: TagSettings] = [:]
var existingTags: [String] = []

func populateTagValuesDict(targetPath: String) -> Void{
    var ruleContent: String = " "
    do{
        ruleContent = try String(contentsOfFile: "\(targetPath)/tagRules.tr")
    } catch {
        print("file tagRules.tr not found at paht \(targetPath)")
        exit(1)
    }
    let ruleParts = ruleContent.split(separator: "\n%---%\n")

    for tagSet in ruleParts{

        var tag = " "
        guard let tagFinalIndex = tagSet.range(of: "\ninitial\n")?.lowerBound else { 
            print("tag \(tag) not well defined!")
            exit(1)
        }
        let tagLine = String(tagSet[..<tagFinalIndex])

        var relatedTags: [String]? = nil
        let HashtagChar: Character = "#"
        if tagLine.filter({$0 == HashtagChar}).count > 1 {
            let tags = tagLine.split(separator: " ").map { String($0) }
            relatedTags = Array(tags[1...])
            tag = String(tags[0])
        }else{
            tag = tagLine
        }
        
        guard let initialRuleStartIndex = tagSet.index(tagSet.range(of: "initial\n")!.lowerBound, offsetBy: 8, limitedBy: tagSet.endIndex) else {
            print("tag \(tag) not well defined!")
            exit(1)
        }

        guard let initialRulefinalIndex = tagSet.range(of: "\nend\n")?.lowerBound else {
            print("tag \(tag) not well defined!")
            exit(1)
        }

        let initialRule = String(tagSet[initialRuleStartIndex..<initialRulefinalIndex])

        guard let endRuleStartIndex = tagSet.index(tagSet.range(of: "end\n")!.lowerBound, offsetBy: 4, limitedBy: tagSet.endIndex) else {
            print("tag \(tag) not well defined!")
            exit(1)
        }

        let endRuleFinalIndex = tagSet.endIndex

        let endRule = String(tagSet[endRuleStartIndex..<endRuleFinalIndex])

        let text: String? = nil

        tagValuesDict[tag] = TagSettings(tag: tag, initial: initialRule, text: text, end: endRule, relatedTags: relatedTags)
        existingTags.append(tag);

    }

    //expecial tags

    tagValuesDict["#<"] = TagSettings(tag: "#<", initial: "", text: nil, end: "\n", relatedTags: nil)
    existingTags.append("#<");
    tagValuesDict["#_"] = TagSettings(tag: "#_", initial: "", text: nil, end: "\n", relatedTags: nil)
    existingTags.append("#<");
}

func getTagSettingsArryByTag(tag: String) -> [TagSettings]{
    guard let tagSettings = tagValuesDict[tag] else {
            print("tag \(tag) not found!")
            exit(1)
        }

    var tagSettingsArry: [TagSettings] = []
    tagSettingsArry.append(tagSettings)
    if tagSettings.relatedTags != nil {
        //for now, realtedTags only has one string
        guard let relatedTagSettings: TagSettings = tagValuesDict[tagSettings.relatedTags![0]] else {
            print("tag \(tagSettings.relatedTags![0]) not found!")
            exit(1)
        }
        tagSettingsArry.append(relatedTagSettings)
    }

    return tagSettingsArry
}
