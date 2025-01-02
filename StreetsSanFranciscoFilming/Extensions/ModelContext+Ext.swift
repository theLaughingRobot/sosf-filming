import SwiftData

extension ModelContext {
  func delete<T: PersistentModel>(model: T.Type) throws {
    let descriptor = FetchDescriptor<T>()
    let items = try fetch(descriptor)
    items.forEach { delete($0) }
  }
}
