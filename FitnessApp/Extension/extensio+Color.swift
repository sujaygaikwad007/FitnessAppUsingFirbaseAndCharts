import Foundation
import SwiftUI

extension Color{
    
    static let theme = ColorTheme()
    static let primaryBG = Color("PrimaryBGColor")
    static let primaryTextColor = Color("PrimaryTextcolor")
    static let PrimaryColor = Color("PrimaryColor")
    static let CustomGray = Color("customGray")

}

struct ColorTheme {
    
    let accent = Color("accentColor")
    let caloriesProgress = Color("caloriesProgress")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
    
}
