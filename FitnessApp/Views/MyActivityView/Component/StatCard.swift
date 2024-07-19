import SwiftUI

struct StatCard: View {
    let activity: ActivityModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            mainTitleAndIcon
            switch activity.title {
            case "Calories", "Walk":
                withAnimation{
                    CircularProgressView(progress: progressValue(), unit: activity.unit, value: activity.amount)
                        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
                }
            case "Sleep", "Training", "Water", "Heart":
                if activity.title == "Water" || activity.title == "Heart" {
                        waterHeartImage
                        
                }
                valueAndUnit
            default:
                Text("Unknown activity")
            }
        }
        .padding(10)
        .frame(width:150,height: cardHeight())
        .background(Color.CustomGray)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
        .padding(.top,activity.title == "Sleep" ||  activity.title == "Training" || activity.title == "Calories" ? -60:0)
        .padding(.bottom,activity.title == "Training" ? -60:0)
    }
}

extension StatCard {
    private func cardHeight() -> CGFloat {
        return (activity.title == "Calories" || activity.title == "Walk" || activity.title == "Water" || activity.title == "Heart") ? 200 : 150
    }
  
    private func progressValue() -> Double {
        
        guard let amountValue = Double(activity.amount) else {
            return 0.0
        }
        
        if activity.title ==  "Calories"{
            let maxValue: Double = 3000
            return min(amountValue / maxValue, 1.0)
        } else if activity.title ==  "Walk" {
            let maxValue: Double = 10000
            return min(amountValue / maxValue, 1.0)
        }else{
            return 0.0
        }
        
    
    }
    
    private var mainTitleAndIcon: some View {
        HStack(alignment:.center) {
            Text(activity.title)
                .font(.Montserrat_SemiBold16px)
                .foregroundColor(.PrimaryColor)
            Spacer()
            Image(systemName: activity.image)
                .padding(.all,5)
                .foregroundColor(.white)
                .frame(alignment: .center)
                .background(activity.IconBGcolor)
                .clipShape(Circle())
                
        }
        .frame(maxWidth: .infinity,alignment: .top)
    }
    
    private var valueAndUnit: some View {
        HStack(spacing: 20) {
            HStack(alignment: .center,spacing: 2) {
                Text(activity.amount)
                    .font(.Montserrat_SemiBold16px)
                    .foregroundColor(.primaryTextColor)
                Text(activity.unit)
                    .font(.Montserrat_Regular10px)
                    .foregroundColor(.secondary)
                    
            }
            .frame(maxWidth: .infinity,alignment: .bottomLeading)
            .foregroundColor(.primaryTextColor)
            Image(systemName: "sleep.circle.fill")
                .font(.title)
                .foregroundColor(.PrimaryColor)
                .opacity(activity.title == "Sleep" ? 1.0 : 0.0)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottom)
    }
    
    private var waterHeartImage: some View {
        Image(activity.title == "Water" ? "Water" : "Heart")
            .renderingMode(.template)
            .resizable()
            .foregroundColor(activity.title == "Water" ? .blue:.orange)
            .scaledToFit()
            .frame(width: 100, height: 50)
            .padding(.top,20)
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
    }
}
struct StatCardPreviews: PreviewProvider {
    static var previews: some View {
        StatCard(activity: ActivityModel(id: 1, title: "Heart", image: "heart", unit: "bmp", amount: "180", IconBGcolor: Color.red))
    }
}
