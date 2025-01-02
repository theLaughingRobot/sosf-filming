import SwiftUI
import MapKit

struct LookAroundPreview: View {
  let coordinate: CLLocationCoordinate2D
  @State private var lookAroundImage: UIImage?
  @State private var isLoading = true
  @State private var error: Error?
  
  var body: some View {
    Group {
      if let image = lookAroundImage {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
      } else if isLoading {
        ProgressView()
      } else if error != nil {
        Text("Look Around not available for this location")
      }
    }
    .task {
      await loadLookAroundImage()
    }
  }
  
  private func loadLookAroundImage() async {
    let scene = MKLookAroundSceneRequest(coordinate: coordinate)
    do {
      guard let lookAroundScene = try await scene.scene else {
        isLoading = false
        return
      }
      
      let snapshotter = MKLookAroundSnapshotter(scene: lookAroundScene, options: MKLookAroundSnapshotter.Options())
      let snapshot = try await snapshotter.snapshot
      lookAroundImage = snapshot.image
    } catch {
      self.error = error
    }
    isLoading = false
  }
}
