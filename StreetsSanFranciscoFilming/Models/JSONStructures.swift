import Foundation

struct ShowData: Codable {
  let seasons: [SeasonData]
}

struct SeasonData: Codable {
  let seasonNumber: Int
  let seasonAirDate: String
  let title: String
  let totalEpisodes: String
  let episodes: [EpisodeData]
}

struct EpisodeData: Codable {
  let episodeNumber: Int
  let episodeTitle: String
  let episodeAirDate: String
  let episodeDescription: String
  let episodeGuestStars: String
  let locations: [LocationData]
  let seasonEpisodeNumber: Int
}

struct LocationData: Codable {
  let locationTitle: String
  let locationInfo: String
  let timeCode: String
  let filmingLocation: CoordinateData
  let imageFilename: String
}

struct CoordinateData: Codable {
  let latitude: Double
  let longitude: Double
}
