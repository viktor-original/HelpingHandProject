//
//  Problem.swift
//  HelpingHand
//
//  Created by Viktor Krasilnikov on 28.08.2018.
//  Copyright © 2018 Viktor Krasilnikov. All rights reserved.
//

import UIKit

struct Problem {
    
    var id: String?
    var type: Int     
    var title: String
    var image: UIImage?
    var status: Int
    var creatorId: String?
    var helperId: String?
    var description: String?
    var xCoordinate: Double?
    var yCoordinate: Double?
    
    mutating func setStatus (_ status: Int) {
        self.status = status
    }
    
    mutating func setHelper(id: String) {
        self.helperId = id
    }
    
    mutating func setCreatorId(_ id: String) {
        self.creatorId = id
    }
    
    mutating func setHelperId(_ id: String) {
        self.helperId = id
    }
    
    mutating func setDescription(_ description: String) {
        self.description = description
    }
    
    mutating func setXCoordinate(_ x: Double) {
        self.xCoordinate = x
    }
    
    mutating func setYCoordinate(_ y: Double) {
        self.yCoordinate = y
    }
    
    static func unsafeInitWith(dictionary dict: Dictionary<String, String>, andDocId docId: String) -> Problem {
    
        let id = docId
        let type = Int(dict["type"]!)
        let title = dict["title"]
        let image = UIImage(named: dict["image"]!)
        let status = Int(dict["status"]!)
        let creatorId = dict["creatorId"]
        let helperId = dict["helperId"]
        let description = dict["description"]
        let xCoordinate = Double(dict["xCoordinate"]!)
        let yCoordinate = Double(dict["yCoordinate"]!)
        
        
        return Problem(id: id, type: type!, title: title!, image: image, status: status!, creatorId: creatorId, helperId: helperId, description: description, xCoordinate: xCoordinate, yCoordinate: yCoordinate)
    }
    
    static let typesDescription = [
        [
            "title" : Constants.CAR_ISSUE,
            "image": "carMalfunction"
        ],
        [
            "title" : Constants.CHILD_LOST,
            "image": "childLost"
        ],
        [
            "title" : Constants.CONFUSED,
            "image": "confused"
        ],
        [
            "title": Constants.CANT_GET_UP,
            "image": "fall"
        ],
        [
            "title": Constants.FIGHT_NEARBY,
            "image": "fight"
        ],
        [
            "title": Constants.SHARE_GOOD_MOOD,
            "image": "goodMood"
        ],
        [
            "title": Constants.HEALTH_ISSUE,
            "image": "healthIssue"
        ],
        [
            "title": Constants.HEAVY_THINGS,
            "image": "helpWomanHeavy"
        ],
        [
            "title": Constants.HELP_FOR_DISABLED,
            "image": "invalid"
        ],
        [
            "title": Constants.I_AM_LATE,
            "image": "late"
        ],
        [
            "title": Constants.HELP_OLDMAN,
            "image": "oldMan"
        ],
        [
            "title": Constants.NEED_CASH,
            "image": "outOfCash"
        ],
        [
            "title": Constants.NEED_TO_CALL,
            "image": "outOfMobileMoney"
        ],
        [
            "title": Constants.SAD,
            "image": "sad"
        ],
        [
            "title": Constants.SLEEPING_AT_STREET,
            "image": "sleepingMan"
        ],
        [
            "title": Constants.SICK_STOMACH,
            "image": "stomach"
        ],
        [
            "title": Constants.STRANGE_FIND,
            "image": "strangeFind"
        ],
        [
            "title": Constants.TOILET_ISSUES,
            "image": "toilet"
        ]
    ]
    
    static func defaultProblems() -> Array<Problem> {
        return [
            Problem(id: nil, type: 0, title: NSLocalizedString(Constants.CAR_ISSUE, comment: ""), image: UIImage(named: "carMalfunction"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 1, title: NSLocalizedString(Constants.CHILD_LOST, comment: ""), image: UIImage(named: "childLost"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 2, title: NSLocalizedString(Constants.CONFUSED, comment: ""), image: UIImage(named: "confused"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 3, title: NSLocalizedString(Constants.CANT_GET_UP, comment: ""), image: UIImage(named: "fall"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 4, title: NSLocalizedString(Constants.FIGHT_NEARBY, comment: ""), image: UIImage(named: "fight"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 5, title: NSLocalizedString(Constants.SHARE_GOOD_MOOD, comment: ""), image: UIImage(named: "goodMood"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 6, title: NSLocalizedString(Constants.HEALTH_ISSUE, comment: ""), image: UIImage(named: "healthIssue"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 7, title: NSLocalizedString(Constants.HEAVY_THINGS, comment: ""), image: UIImage(named: "helpWomanHeavy"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 8, title: NSLocalizedString(Constants.HELP_FOR_DISABLED, comment: ""), image: UIImage(named: "invalid"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 9, title: NSLocalizedString(Constants.I_AM_LATE, comment: ""), image: UIImage(named: "late"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 10, title: NSLocalizedString(Constants.HELP_OLDMAN, comment: ""), image: UIImage(named: "oldMan"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 11, title: NSLocalizedString(Constants.NEED_CASH, comment: ""), image: UIImage(named: "outOfCash"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 12, title: NSLocalizedString(Constants.NEED_TO_CALL, comment: ""), image: UIImage(named: "outOfMobileMoney"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 13, title: NSLocalizedString(Constants.SAD, comment: ""), image: UIImage(named: "sad"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 14, title: NSLocalizedString(Constants.SLEEPING_AT_STREET, comment: ""), image: UIImage(named: "sleepingMan"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 15, title: NSLocalizedString(Constants.SICK_STOMACH, comment: ""), image: UIImage(named: "stomach"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 16, title: NSLocalizedString(Constants.STRANGE_FIND, comment: ""), image: UIImage(named: "strangeFind"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil),
            Problem(id: nil, type: 17, title: NSLocalizedString(Constants.TOILET_ISSUES, comment: ""), image: UIImage(named: "toilet"), status: 0, creatorId: nil, helperId: nil, description: nil, xCoordinate: nil, yCoordinate: nil)
        ]
    }
    
}
