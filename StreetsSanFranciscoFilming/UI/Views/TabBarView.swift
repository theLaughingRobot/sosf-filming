import SwiftData
import SwiftUI

struct TabBarView: View {
  @Environment(\.modelContext) private var modelContext
  @State private var filmingVM: FilmingViewModel
  
  init(modelContext: ModelContext) {
    _filmingVM = State(initialValue: FilmingViewModel(modelContext: modelContext))
  }
  
  var body: some View {
    TabView {
      SeasonListView(filmingVM: filmingVM)
        .tabItem {
          Label("Seasons", systemImage: "list.bullet")
        }
      MapView(filmingVM: filmingVM)
        .tabItem {
          Label("Map", systemImage: "map")
        }
    }
    .tint(.primaryOrange)
  }
}
