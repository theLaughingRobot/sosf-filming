import Foundation
import SwiftData

class DataLoader {
  static func loadData(modelContext: ModelContext) {
    clearExistingData(modelContext: modelContext)
    
    for seasonNumber in 1...5 {
      loadSeason(seasonNumber: seasonNumber, modelContext: modelContext)
    }
    
    do {
      try modelContext.save()
    } catch {
      print("Failed to save context: \(error)")
    }
  }
  
  private static func clearExistingData(modelContext: ModelContext) {
    do {
      try modelContext.delete(model: Season.self)
      try modelContext.delete(model: Episode.self)
      try modelContext.delete(model: Location.self)
    } catch {
      print("Failed to clear existing data: \(error)")
    }
  }
  
  private static func loadSeason(seasonNumber: Int, modelContext: ModelContext) {
    let filename = "season\(seasonNumber)"
    
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
      print("Could not find \(filename).json in bundle")
      return
    }
    
    do {
      let data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      let seasonData = try decoder.decode(SeasonData.self, from: data)
      
      let season = Season(
        seasonAirDate: seasonData.seasonAirDate,
        title: seasonData.title,
        totalEpisodes: seasonData.totalEpisodes,
        seasonNumber: seasonData.seasonNumber
      )
      modelContext.insert(season)
      
      for episodeData in seasonData.episodes {
        let episode = Episode(
          episodeAirDate: episodeData.episodeAirDate,
          episodeDescription: episodeData.episodeDescription,
          episodeGuestStars: episodeData.episodeGuestStars,
          episodeNumber: episodeData.episodeNumber,
          episodeTitle: episodeData.episodeTitle,
          seasonEpisodeNumber: episodeData.seasonEpisodeNumber
        )
        episode.season = season
        modelContext.insert(episode)
        
        for locationData in episodeData.locations {
          let imageData: Data? = loadImageData(filename: locationData.imageFilename)
          
          let location = Location(
            locationInfo: locationData.locationInfo,
            filmingLocation: Coordinate(
              latitude: locationData.filmingLocation.latitude,
              longitude: locationData.filmingLocation.longitude
            ),
            locationImage: imageData,
            locationTitle: locationData.locationTitle,
            timeCode: locationData.timeCode
          )
          location.episode = episode
          modelContext.insert(location)
        }
      }
    } catch {
      print("Failed to load or decode \(filename).json: \(error)")
    }
  }
  
  private static func loadImageData(filename: String) -> Data? {
    guard let url = Bundle.main.url(forResource: filename.components(separatedBy: ".").first,
                                    withExtension: filename.components(separatedBy: ".").last) else {
      print("Could not find image: \(filename)")
      return nil
    }
    return try? Data(contentsOf: url)
  }
}
