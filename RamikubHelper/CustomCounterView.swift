//
//  CustomCounterView.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 10/29/24.
//

import SwiftUI
import CoreGraphics

struct CustomStepper: View {
    @Binding var count: Int
    
    let range = 1..<300
    let countdownPie = Pie()

    var body: some View {
        ZStack {
            countdownPie
                .fill(.gray)
                .opacity(0.3)
                .frame(width: 200, height:  200)
            HStack {
                Button(action: {
                    count -= 1
                }) {
                    Image(systemName: "minus")
                        .font(.headline)
                }
                .disabled(count == range.lowerBound)
                
                Text("\(count)")
                    .font(.system(size: 50))
                    .padding()
                
                Button(action: {
                    count += 1
                }) {
                    Image(systemName: "plus")
                        .font(.headline)
                }
                .disabled(count == range.upperBound)
            }
        }
    }
}

struct Pie: Shape {
    var startAngle: Angle = .zero
    let endAngle: Angle = .degrees(360)
    var clockwise = true
    
    func path(in rect: CGRect) -> Path {
        let startAngle = startAngle - .degrees(90)
        let endAngle = endAngle - .degrees(90)
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(startAngle.radians),
            y: center.y + radius * sin(startAngle.radians)
        )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: !clockwise
        )
        p.addLine(to: center)
        return p
    }
}



#Preview {
    @Previewable @State var counterValue: Int = 0
    CustomStepper(count: $counterValue)
}
