//
//  User.swift
//  HelpingHand
//
//  Created by Viktor Krasilnikov on 28.08.2018.
//  Copyright © 2018 Viktor Krasilnikov. All rights reserved.
//

import UIKit

struct User {
    
    enum Sex : String {
        case male
        case female
        case unknown
    }
    
    var id: String?
    var email: String
    var firstName: String?
    var lastName: String?
    var age: UInt?
    var sex: Sex?
    var phoneNumber: String?
    var avatar: UIImage?
    var contacts: Array<Dictionary<String, String>>?
    
    var fullName: String {
        get {
            guard let firstName = self.firstName, let lastName = self.lastName else {
                return "User"
            }
            return firstName + " " + lastName
        }
    }
    
    static func initWithPrimitives(id: String?,
                                   firstName: String?,
                                   lastName: String?,
                                   avatar: String?,
                                   sex: String?,age: String?,
                                   email: String,
                                   phoneNumber: String?,
                                   contacts: Array<Dictionary<String, String>>?) -> User {
        
        
        var sexForInit: Sex?
        
        if sex != nil {
            switch sex {
            case User.Sex.male.rawValue:
                sexForInit = .male
            case User.Sex.female.rawValue:
                sexForInit = .female
            default:
                sexForInit = .unknown
            }
        }
        var unwrappedAge: UInt = 0
        if let supposedAge = age {
            unwrappedAge = UInt(supposedAge) ?? 0
        }
        
        return User(id: id,
                    email: email,
                    firstName: firstName,
                    lastName: lastName,
                    age: UInt(unwrappedAge),
                    sex: sexForInit,
                    phoneNumber: phoneNumber,
                    avatar: UIImage(named: avatar ?? "emptyAvatar"),
                    contacts: contacts)
    }
    
    mutating func add(contact: Dictionary<String,String>) {
        
        if self.contacts != nil {
            self.contacts!.append(contact)
        } else {
            self.contacts = [contact]
        }
    }
    
    func filledRequisitesCount() -> Int {
        
        var count: Int = 1
        
        if self.firstName != nil {
            count += 1
        }
        
        if self.lastName != nil {
            count += 1
        }
        
        if self.sex != Sex.unknown {
            count += 1
        }
        
        if self.phoneNumber != nil {
            count += 1
        }
        
        if self.age != 0 {
            count += 1
        }
        
        return count
    }
    
    static func initiateUser() -> User {
        
        let defaults = UserDefaults.standard
        
        let id = defaults.string(forKey: "id")
        let email = defaults.string(forKey: "email") ?? ""
        let firstName = defaults.string(forKey: "firstName") ?? "not set"
        let lastName = defaults.string(forKey: "lastName") ?? "not set"
        let avatar = defaults.string(forKey: "avatar") ?? "emptyAvatar"
        let age = UInt(defaults.integer(forKey: "age"))
        let sexString = defaults.string(forKey: "sex") ?? "unknown"
        let phoneNumber = defaults.string(forKey: "phoneNumber") ?? "not set"
        let contacts = defaults.array(forKey: "contacts") as? Array<Dictionary<String,String>>
        
        let user = User.initWithPrimitives(id: id,
                                           firstName: firstName,
                                           lastName: lastName,
                                           avatar: avatar,
                                           sex: sexString,
                                           age: "\(age)",
                                           email: email,
                                           phoneNumber: phoneNumber,
                                           contacts: contacts
        )
        
        return user
    }
    
    static func initiateDefaultUser() -> User {
        return User.initWithPrimitives(id: "47", firstName: "Артём", lastName: "Борисенко", avatar: "advent", sex: "male", age: "30", email: "en.garret@gmail.com", phoneNumber: "375295938186", contacts: [
            ["name":"Мама", "phoneNumber":"телефон мамы"],
            ["name":"Папа", "phoneNumber":"телефон папы"],
            ["name":"Колян", "phoneNumber":"телефон Коляна"]
            ])        
    }
    
    static func update(user: User){
        
        let defaults = UserDefaults.standard
        
        defaults.set(user.id, forKey: "id")
        defaults.set(user.firstName, forKey: "firstName")
        defaults.set(user.lastName, forKey: "lastName")
        defaults.set("advent", forKey: "avatar")
        defaults.set(user.age, forKey: "age")
        defaults.set(user.sex!.rawValue, forKey: "sex")
        defaults.set(user.email, forKey: "email")
        defaults.set(user.phoneNumber, forKey: "phoneNumber")
        defaults.set(user.contacts, forKey: "contacts")
    }
}







