import Foundation

//Format a number double to int
extension Double{
    func formattedString() ->String?{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
