import SwiftUI

struct LineTextLine: View {
    var text: String
    var lineColor: Color = .black
    var lineHeight: CGFloat = 1
    var padding: CGFloat = 5
    
    var body: some View {
        HStack{
            Rectangle()
                .frame(height: lineHeight)
                .foregroundColor(lineColor)
            
            Text(text)
                .padding(.horizontal, padding)
            
            Rectangle()
                .frame(height: lineHeight)
                .foregroundColor(lineColor)
            
        }
        .padding(.horizontal,20)
    }
    
}

struct LineTextLine_Previews: PreviewProvider {
    static var previews: some View {
        LineTextLine(text: "or")
           
            .preferredColorScheme(.dark)
    }
}
