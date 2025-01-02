import SwiftUI
import SwiftData

@main
struct TVShowApp: App {
  let container: ModelContainer
  
  init() {
    do {
      let schema = Schema([Season.self, Episode.self, Location.self])
      let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
      container = try ModelContainer(for: schema, configurations: [modelConfiguration])
      
      let filmingVM = FilmingViewModel(modelContext: container.mainContext)
      filmingVM.loadInitialData()
    } catch {
      fatalError("Could not initialize ModelContainer: \(error)")
    }
  }
  
  var body: some Scene {
    WindowGroup {
      TabBarView(modelContext: container.mainContext)
    }
    .modelContainer(container)
  }
}
