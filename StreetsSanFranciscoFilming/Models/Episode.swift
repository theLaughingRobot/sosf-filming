import Foundation
import SwiftData

@Model
final class Episode {
  var episodeAirDate: String
  var episodeDescription: String
  var episodeGuestStars: String
  var episodeNumber: Int
  var episodeTitle: String
  var seasonEpisodeNumber: Int
  
  @Relationship(inverse: \Season.episodes) var season: Season?
  @Relationship(deleteRule: .cascade) var locations: [Location] = []
  
  init(episodeAirDate: String, episodeDescription: String, episodeGuestStars: String, episodeNumber: Int, episodeTitle: String, seasonEpisodeNumber: Int) {
    self.episodeAirDate = episodeAirDate
    self.episodeDescription = episodeDescription
    self.episodeGuestStars = episodeGuestStars
    self.episodeNumber = episodeNumber
    self.episodeTitle = episodeTitle
    self.seasonEpisodeNumber = seasonEpisodeNumber
  }
}
