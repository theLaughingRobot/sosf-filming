import SwiftUI

struct ActivityIndicator: View {
  @State private var isAnimating: Bool = false
  
  var body: some View {
    GeometryReader { (geometry: GeometryProxy) in
      ForEach(0..<8) { index in
        Group {
          Circle()
            .frame(width: geometry.size.width / 8, height: geometry.size.height / 8)
            .scaleEffect(calcScale(index: index))
            .offset(y: calcYOffset(geometry))
        }.frame(width: geometry.size.width, height: geometry.size.height)
          .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
          .animation(Animation
            .timingCurve(0.5, 0.15 + Double(index) / 8, 0.25, 1, duration: 1.0)
            .repeatForever(autoreverses: false))
      }
    }
    .aspectRatio(1, contentMode: .fit)
    .onAppear {
      self.isAnimating = true
    }
  }
  
  func calcScale(index: Int) -> CGFloat {
    return (!isAnimating ? 1 - CGFloat(Float(index)) / 5 : 0.2 + CGFloat(index) / 5)
  }
  
  func calcYOffset(_ geometry: GeometryProxy) -> CGFloat {
    return geometry.size.width / 10 - geometry.size.height / 2
  }
}

struct EpisodeLoader: View {
  var body: some View {
    ZStack {
      Color(UIColor.secondarySystemBackground)
        .edgesIgnoringSafeArea(.horizontal)
      ActivityIndicator()
        .frame(width: 100, height: 100)
        .foregroundColor(.orange)
    }
  }
}

#Preview {
  ActivityIndicator()
}
