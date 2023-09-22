//
//  ContentView.swift
//  Drawing
//
//  Created by Maciej Wiącek on 18/09/2023.
//

import SwiftUI

struct Arrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.closeSubpath()
        
        return path
    }
}

struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100
    
    var startPosX = 0.5
    var startPosY = 0.0
    
    var endPosX = 1.0
    var endPosY = 0.5
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: Double(value))
                    .strokeBorder(
                        LinearGradient(
                        gradient: Gradient(colors: [
                            color(for: value, brightness: 1),
                            color(for: value, brightness: 0.5)
                        ]),
                        startPoint: UnitPoint(x: startPosX, y: startPosY),
                        endPoint: UnitPoint(x: endPosX, y: endPosY))
                    )
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ContentView: View {
    @State private var arrowLineWidth = 2.0
    
    @State private var startPosX = 0.5
    @State private var startPosY = 0.0
    
    @State private var endPosX = 1.0
    @State private var endPosY = 0.5
    
    var body: some View {
        VStack {
            Arrow()
                .stroke(.black, style: StrokeStyle(lineWidth: arrowLineWidth, lineCap: .round, lineJoin: .round))
                .frame(width: 150, height: 150)
                .padding()
            
            HStack {
                Button("-") {
                    withAnimation(.default) {
                        arrowLineWidth -= 5
                    }
                }
                .frame(width: 100, height: 50)
                .background(.red)
                .clipShape(Capsule())
                .padding(.horizontal)
                
                Button("+") {
                    withAnimation(.default) {
                        arrowLineWidth += 5
                    }
                }
                .frame(width: 100, height: 50)
                .background(.green)
                .clipShape(Capsule())
                .padding(.horizontal)
            }
            .padding(.bottom)
            
            ColorCyclingRectangle(startPosX: startPosX, startPosY: startPosY, endPosX: endPosX, endPosY: endPosY)
            
            Group {
                Slider(value: $startPosX, in: 0...1)
                    .padding(.horizontal)
                
                Slider(value: $startPosY, in: 0...1)
                    .padding(.horizontal)
                
                Slider(value: $endPosX, in: 0...1)
                    .padding(.horizontal)
                
                Slider(value: $endPosY, in: 0...1)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ContentView()
}
