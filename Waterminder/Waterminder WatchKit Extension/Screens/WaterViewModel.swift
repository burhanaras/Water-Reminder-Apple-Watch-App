import Foundation
import UIKit
import UserNotifications

class WaterViewModel: ObservableObject {
    @Published
    var drinkingAmount: Double = 200.0
    var drinkingTarget = AppData.target
    var waterLevel: CGFloat = .zero
    
    var isGoalReached: Bool {
        round(drinkingTarget) == .zero
    }
    
    var targetText: String {
        isGoalReached
            ? "💦 Nice job! 💦"
            : "Target: \(drinkingTarget.toMilliliters())"
    }
    
    var minimumInterval: Double {
        min(50, drinkingTarget)
    }
    
    var drinkText: String {
        drinkingAmount.toMilliliters()
    }
    
    func didTapDrink() {
        guard floor(drinkingTarget - drinkingAmount) >= .zero else { return }
        drinkingTarget -= round(drinkingAmount)
        waterLevel += CGFloat(drinkingAmount / 10)
        drinkingAmount = min(drinkingAmount, drinkingTarget)
        if isGoalReached {
            cancelLocalNotifications()
        }
    }
    
    func didTapReset() {
        waterLevel = .zero
        drinkingTarget = AppData.target
        drinkingAmount = 200
        registerLocalNotifications()
    }
    
    
    func registerLocalNotifications() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("We have granted local notifications.")
                AppData.isNotificationAuthorized = true
                self.scheduleLocalNotifications()
            } else {
                print("We haven't granted local notifications.")
            }
        }
    }
    
    func scheduleLocalNotifications() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Water Time!"
        content.body = "Drink one more glass of water, stay healthy."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func cancelLocalNotifications(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
