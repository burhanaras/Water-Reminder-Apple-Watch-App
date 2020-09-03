//
//  AppData.swift
//  Waterminder WatchKit Extension
//
//  Created by Burhan Aras on 26.08.2020.
//  Copyright © 2020 Carlos Corrêa. All rights reserved.
//

import Foundation


struct AppData{
    
    @Storage(key: "waterReminderTarget", defaultValue: 4000)
    static var target: Double
    
    @Storage(key: "waterReminderWeight", defaultValue: 82)
    static var weight: Double
    
    @Storage(key: "waterReminderDailyWorkOut", defaultValue: 32)
    static var dailyWorkOut: Double
    
    @Storage(key: "waterReminderShowIntro", defaultValue: true)
    static var showIntro: Bool
    
    @Storage(key: "waterReminderIsNotificationAuthorized", defaultValue: false)
    static var isNotificationAuthorized: Bool
}
