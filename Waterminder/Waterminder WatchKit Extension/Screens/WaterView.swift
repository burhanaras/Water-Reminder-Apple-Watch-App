import Combine
import SwiftUI

struct WaterView: View {
    @ObservedObject var viewModel: WaterViewModel
    @State var isShowingMenu = false
    
    var body: some View {
        WavingBackground(fill: viewModel.waterLevel) {
            VStack {
                
                if AppData.showIntro{
                    introScreen()
                } else{
                    targetLabel()
                    if viewModel.isGoalReached {
                        resetButton()
                    } else {
                        DrinkButton(text: viewModel.drinkText, action: viewModel.didTapDrink)
                    }
                }
                
            }
        }
        .focusable()
        .digitalCrownRotation($viewModel.drinkingAmount, from: viewModel.minimumInterval, through: viewModel.drinkingTarget, by: 50, sensitivity: .low)
        .edgesIgnoringSafeArea(.all)
        .contextMenu(menuItems: {
            setupButton()
            resetButton()
        })
            .sheet(isPresented: $isShowingMenu) { self.menu() }
    }
}

extension WaterView {
    func introScreen() -> some View{
        VStack (alignment: .center) {
            Spacer()
            Text("💦 Welcome 💦").font(.system(.headline, design: .rounded))
            Text("Let's see whether you are drinking enough water. \nThe calculator will work out your hydration level based on your weight and your daily working habits.")
                .font(.system(size: 10, weight: .semibold, design: .rounded)).multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            Button(action: {
                AppData.showIntro = false
                self.isShowingMenu.toggle()
            }){
                Text("OK")
            }
            Spacer()
        }
    }
    
    func targetLabel() -> some View {
        Text(viewModel.targetText)
            .font(.system(size: 20, weight: .semibold, design: .rounded))
    }
    
    func menu() -> some View {
        SetupView(target: AppData.target, weight: AppData.weight, dailyWorkOut: AppData.dailyWorkOut) { newTarget in
            self.viewModel.didTapReset()
            self.viewModel.drinkingTarget = newTarget
            self.isShowingMenu.toggle()
            
            if AppData.isNotificationAuthorized{
                self.viewModel.scheduleLocalNotifications()
            }else{
                self.viewModel.registerLocalNotifications()
            }
        }
    }
    
    func setupButton() -> some View {
        Button(action: {
            self.isShowingMenu.toggle()
        }) { Text("Setup").padding() }
    }
    
    func resetButton() -> some View {
        Button(action: {
            withAnimation { self.viewModel.didTapReset() }
        }) { Text("Reset!") }
            .padding(.horizontal, 40)
            .offset(x: 0, y: 40)
            .accentColor(.black)
    }
}

struct WaterView_Previews: PreviewProvider {
    static var previews: some View {
        WaterView(viewModel: WaterViewModel())
    }
}
