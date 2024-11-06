//
//  StateHandler.swift
//  Smash
//
//  Created by Abdullah B on 04/11/2024.
//

import Observation


@Observable final class ViewingStatesModel {
    
    static let shared = ViewingStatesModel()

    private(set) var showloginLayer: Bool = false
    private(set) var logintohome: Bool = false
    private(set) var logintoregistration : Bool = false
    private(set) var startsessiontoaccount : Bool = false
    private(set) var accounttostartsession : Bool = false
    private(set) var logout : Bool = false
    private(set) var madeaccount : Bool = false
    private(set) var startingagame : Bool = false
    private(set) var previewinggame : Bool = false
    
    private init(){}
    
    func reset(){
        logout = true
        logintohome = false
        logintoregistration = false
        startsessiontoaccount = false
        accounttostartsession = false
        madeaccount = false
        startingagame = false
        previewinggame = false
    }
    
    func LoggedInToggle(){
        showloginLayer.toggle()
    }
    
    func LoginToHomeToggle(){
        logintohome.toggle()
    }
    
    func ToRegistrationToggle(){
        logintoregistration.toggle()
    }
    
    func AccountsettingToggle(){
        startsessiontoaccount.toggle()
    }
    
    func AccountBackToHomeToggle(back : Int){
         accounttostartsession = (back == 1) ? true : false
    }
    
    func LogoutToggle(){
        logout = false
    }
    
    func MadeAccountToggle(){
        madeaccount.toggle()
    }
    
    func StartingGameToggle(){
        startingagame.toggle()
    }
    
    func PreviewingGameToggle(){
        previewinggame.toggle()
    }
    
}
