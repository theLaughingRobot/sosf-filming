import SwiftUI

struct HeaderGradient: View {
  var gradientColor: Color = Color.gray700
  
  var body: some View {
    LinearGradient(
      gradient: Gradient(colors: [
        gradientColor.opacity(1.0),
        gradientColor.opacity(1.0),
        gradientColor.opacity(1.0),
        gradientColor.opacity(0.9),
        gradientColor.opacity(0.8),
        gradientColor.opacity(0.7),
        gradientColor.opacity(0.6),
        gradientColor.opacity(0.4),
        gradientColor.opacity(0.0)
      ]),
      startPoint: .top,
      endPoint: .bottom
    )
    .frame(height: Constants.Sizes.headerHeight)
    .ignoresSafeArea(edges: .top)
  }
}
