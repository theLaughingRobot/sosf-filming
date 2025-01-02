import Foundation
import SwiftData

@Model
final class Season {
  var seasonAirDate: String
  var title: String
  var totalEpisodes: String
  var seasonNumber: Int
  
  @Relationship(deleteRule: .cascade) var episodes: [Episode] = []
  
  init(seasonAirDate: String, title: String, totalEpisodes: String, seasonNumber: Int) {
    self.seasonAirDate = seasonAirDate
    self.title = title
    self.totalEpisodes = totalEpisodes
    self.seasonNumber = seasonNumber
  }
}
