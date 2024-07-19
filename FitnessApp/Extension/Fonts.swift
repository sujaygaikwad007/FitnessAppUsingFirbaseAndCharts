//
//  Fonts.swift
//  FitnessApp
//
//  Created by Sachin Patil on 17/07/24.
//

import Foundation
import SwiftUI
extension Font {
    
    
    
    //Montserrat Font
    //Font Size 10px
    static let Montserrat_Regular10px = Font(UIFont(name: "Inter-Regular", size: 10)!)
    static let Montserrat_SemiBold10px =  Font(UIFont(name: "Inter-SemiBold", size: 10)!)
    static let Montserrat_Bold10px =  Font(UIFont(name: "Inter-Bold", size: 10)!)
    static let Montserrat_ExtraBold10px =  Font(UIFont(name: "Inter-ExtraBold", size: 10)!)
    
    //Font Size 12px
    static let Montserrat_Regular12px = Font(UIFont(name: "Inter-Regular", size: 12)!)
    static let Montserrat_Medium12px =  Font(UIFont(name: "Inter-Medium", size: 12)!)
    static let Montserrat_SemiBold12px =  Font(UIFont(name: "Inter-SemiBold", size: 12)!)
    static let Montserrat_Bold12px =  Font(UIFont(name: "Inter-Bold", size: 12)!)
    static let Montserrat_ExtraBold12px =  Font(UIFont(name: "Inter-ExtraBold", size: 12)!)
    
    //Font Size 14px
    static let Montserrat_Regular14px = Font(UIFont(name: "Inter-Regular", size: 14)!)
    static let Montserrat_Medium14px =  Font(UIFont(name: "Inter-Medium", size: 14)!)
    static let Montserrat_SemiBold14px =  Font(UIFont(name: "Inter-SemiBold", size: 14)!)
    static let Montserrat_Bold14px =  Font(UIFont(name: "Inter-Bold", size: 14)!)
    static let Montserrat_ExtraBold14px =  Font(UIFont(name: "Inter-ExtraBold", size: 14)!)
    //Font Size 15px
    static let Montserrat_Regular15px = Font(UIFont(name: "Inter-Regular", size: 15)!)
    static let Montserrat_Bold15px =  Font(UIFont(name: "Inter-Bold", size: 15)!)
    
    //Font Size 16px
    static let Montserrat_Regular16px = Font(UIFont(name: "Inter-Regular", size: 16)!)
    static let Montserrat_SemiBold16px =  Font(UIFont(name: "Inter-SemiBold", size: 16)!)
    static let Montserrat_Medium16px =  Font(UIFont(name: "Inter-Medium", size: 16)!)
    static let Montserrat_Bold16px =  Font(UIFont(name: "Inter-Bold", size: 16)!)
    static let Montserrat_ExtraBold16px =  Font(UIFont(name: "Inter-ExtraBold", size: 16)!)
    
    //Font Size 18px
    static let Montserrat_Regular18px = Font(UIFont(name: "Inter-Regular", size: 18)!)
    static let Montserrat_Medium18px =  Font(UIFont(name: "Inter-Medium", size: 18)!)
    static let Montserrat_SemiBold18px =  Font(UIFont(name: "Inter-SemiBold", size: 18)!)
    static let Montserrat_Bold18px =  Font(UIFont(name: "Inter-Bold", size: 18)!)
    static let Montserrat_ExtraBold18px =  Font(UIFont(name: "Inter-ExtraBold", size: 18)!)
    
    //Font Size 20px
    static let Montserrat_Regular20px = Font(UIFont(name: "Inter-Regular", size: 20)!)
    static let Montserrat_SemiBold20px =  Font(UIFont(name: "Inter-SemiBold", size: 20)!)
    static let Montserrat_Bold20px =  Font(UIFont(name: "Inter-Bold", size: 20)!)
    static let Montserrat_ExtraBold20px =  Font(UIFont(name: "Inter-ExtraBold", size: 20)!)
    
    //Font Size 22px
    static let Montserrat_Regular22px = Font(UIFont(name: "Inter-Regular", size: 22)!)
    static let Montserrat_SemiBold22px =  Font(UIFont(name: "Inter-SemiBold", size: 22)!)
    static let Montserrat_Bold22px =  Font(UIFont(name: "Inter-Bold", size: 22)!)
    static let Montserrat_ExtraBold22px =  Font(UIFont(name: "Inter-ExtraBold", size: 22)!)
    
    
    //Font Size 24px
    static let Montserrat_Regular24px = Font(UIFont(name: "Inter-Regular", size: 24)!)
    static let Montserrat_SemiBold24px =  Font(UIFont(name: "Inter-SemiBold", size: 24)!)
    static let Montserrat_Bold24px =  Font(UIFont(name: "Inter-Bold", size: 24)!)
    static let Montserrat_ExtraBold24px =  Font(UIFont(name: "Inter-ExtraBold", size: 24)!)
    
    //Other Size
    static let Montserrat_Medium11px =  Font(UIFont(name: "Inter-Medium", size: 11)!)
    static let Montserrat_SemiBoldItalic20px =  Font(UIFont(name: "Montserrat-SemiBoldItalic", size: 20)!)
    static let Montserrat_ExtraBold30px =  Font(UIFont(name: "Inter-ExtraBold", size: 30)!)
    static let Montserrat_SemiBold32px =  Font(UIFont(name: "Inter-SemiBold", size: 32)!)
    static let Montserrat_ExtraBold34px =  Font(UIFont(name: "Inter-ExtraBold", size: 34)!)
    static let Montserrat_Bold34px =  Font(UIFont(name: "Inter-Bold", size: 34)!)
    static let Montserrat_Bold30px =  Font(UIFont(name: "Inter-Bold", size: 30)!)
    static let Montserrat_Bold32px =  Font(UIFont(name: "Inter-Bold", size: 32)!)
    static let Montserrat_Bold40px =  Font(UIFont(name: "Inter-Bold", size: 40)!)
    static let Montserrat_Bold41px =  Font(UIFont(name: "Inter-Bold", size: 41)!)
    static let Montserrat_SemiBold36px =  Font(UIFont(name: "Inter-SemiBold", size: 36)!)
}
extension View{
    func removeWhitespacesFromString(mStr: String) -> String {

       let chr = mStr.components(separatedBy: .whitespaces)
       let resString = chr.joined()
       return resString
    }
}
