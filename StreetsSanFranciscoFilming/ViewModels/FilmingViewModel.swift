import MapKit
import SwiftData
import SwiftUI

@Observable
class FilmingViewModel: ObservableObject {
  private var modelContext: ModelContext
  
  var filteredSeason: FilteredSeasons = .season1
  var isMapSheetPresented: Bool = false
  var isSheetPresented: Bool = false
  var mapLocations: [Location] = []
  var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
  var seasons: [Season] = []
  var episodes: [Episode] = []
  var selectedSeason: Season?
  var selectedEpisode: Episode?
  var selectedLocation: Location?
  
  var locationsToShow: [Location] {
    if let season = selectedSeason {
      if let episode = selectedEpisode {
        return getLocationsForEpisode(episode)
      }
      return getLocationsForSeason(season)
    } else {
      return getAllLocations()
    }
  }
  
  var seasonToShow: String {
    if let season = selectedSeason {
      return "Season \(season.seasonNumber)"
    } else {
      return "All Seasons"
    }
  }
  
  var episodeToShow: String {
    if let episode = selectedEpisode {
      return "Episode \(episode.episodeNumber)"
    } else {
      return "All Episodes"
    }
  }
  
  var showError = false
  var errorMessage = ""
  
  init(modelContext: ModelContext) {
    self.modelContext = modelContext
    loadSeasons()
  }
  
  // MARK: - Data Loading
  func loadSeasons() {
    do {
      let descriptor = FetchDescriptor<Season>(sortBy: [SortDescriptor(\.seasonNumber)])
      seasons = try modelContext.fetch(descriptor)
    } catch {
      handleError(error: error, message: "Failed to load seasons")
    }
  }
  
  func loadEpisodesForSeason(_ season: Season) -> [Episode] {
    episodes = season.episodes.sorted { $0.episodeNumber < $1.episodeNumber }
    return episodes
  }
  
  func loadLocationsForEpisode(_ episode: Episode) -> [Location] {
    episode.locations.sorted { $0.timeCode < $1.timeCode }
  }
  
  // MARK: - Selection Handlers
  func selectSeason(_ season: Season) {
    selectedSeason = season
    selectedEpisode = nil
    selectedLocation = nil
  }
  
  func selectEpisode(_ episode: Episode) {
    selectedEpisode = episode
    selectedLocation = nil
  }
  
  func selectLocation(_ location: Location) {
    selectedLocation = location
  }
  
  // MARK: - Data Loading from JSON
  func loadInitialData() {
    clearExistingData()
    
    for seasonNumber in 1...5 {
      loadSeasonFromJSON(seasonNumber: seasonNumber)
    }
    
    loadSeasons()
  }
  
  func getEpisodeForLocation(_ location: Location) -> Episode? {
    return location.episode
  }
  
  func getSeasonForLocation(_ location: Location) -> Season? {
    return location.episode?.season
  }
  
  func getLocationsForSeason(_ season: Season) -> [Location] {
    var locations: [Location] = []
    for episode in season.episodes {
      locations.append(contentsOf: episode.locations)
    }
    return locations
  }
  
  func getLocationsForEpisode(_ episode: Episode) -> [Location] {
    var locations: [Location] = []
    locations.append(contentsOf: episode.locations)
    return locations
  }
  
  func getAllLocations() -> [Location] {
    var locations: [Location] = []
    for season in seasons {
      locations.append(contentsOf: getLocationsForSeason(season))
    }
    return locations
  }
  
  func getLocationDetailTitle(_ location: Location) -> String {
    if let episode = location.episode,
       let season = episode.season {
      return "S\(season.seasonNumber)E\(episode.episodeNumber) - \(location.locationTitle)"
    }
    return location.locationTitle
  }
  
  func getEpisodeInfo(_ location: Location) -> String {
    guard let episode = getEpisodeForLocation(location),
          let season = getSeasonForLocation(location) else {
      return "Unknown Episode"
    }
    return "Season \(season.seasonNumber) Episode \(episode.episodeNumber): \(episode.episodeTitle)"
  }
  
  func getLocationLabel() -> String {
    let val = locationsToShow.count == 1 ? "Location" : "Locations"
    return "\(locationsToShow.count) \(val)"
  }
  
  func getColorFromSeason(season: Season) -> Color {
    switch season.seasonNumber {
    case 1:
      return Color(.seasonOne)
    case 2:
      return Color(.seasonTwo)
    case 3:
      return Color(.seasonThree)
    case 4:
      return Color(.seasonFour)
    case 5:
      return Color(.seasonFive)
    default:
      return Color.black
    }
  }
  
  func getColorFromEpisode(episode: Episode) -> Color {
    switch episode.seasonEpisodeNumber {
    case 1000...1050:
      return Color(.seasonOne)
    case 2000...2050:
      return Color(.seasonTwo)
    case 3000...3050:
      return Color(.seasonThree)
    case 4000...4050:
      return Color(.seasonFour)
    case 5000...5050:
      return Color(.seasonFive)
    default:
      return Color.black
    }
  }
  
  func getColorFromMapSeason() -> Color {
    guard (selectedSeason != nil) else {
      return Color.primaryOrange
    }
    
    switch selectedSeason?.seasonNumber {
    case 1:
      return Color(.seasonOne)
    case 2:
      return Color(.seasonTwo)
    case 3:
      return Color(.seasonThree)
    case 4:
      return Color(.seasonFour)
    case 5:
      return Color(.seasonFive)
    default:
      return Color.black
    }
  }
  
  func getPinColorFromSeason() -> Color {
    guard (selectedSeason != nil) else {
      return .primaryOrange
    }
    
    switch selectedSeason?.seasonNumber {
    case 1:
      return Color(.seasonOne)
    case 2:
      return Color(.seasonTwo)
    case 3:
      return Color(.seasonThree)
    case 4:
      return Color(.seasonFour)
    case 5:
      return Color(.seasonFive)
    default:
      return Color.black
    }
  }
  
  func fitMapToLocations(_ locations: [Location]) {
    guard !locations.isEmpty else { return }
    
    var minLat = locations[0].filmingLocation.latitude
    var maxLat = locations[0].filmingLocation.latitude
    var minLon = locations[0].filmingLocation.longitude
    var maxLon = locations[0].filmingLocation.longitude
    
    for location in locations {
      minLat = min(minLat, location.filmingLocation.latitude)
      maxLat = max(maxLat, location.filmingLocation.latitude)
      minLon = min(minLon, location.filmingLocation.longitude)
      maxLon = max(maxLon, location.filmingLocation.longitude)
    }
    
    let center = CLLocationCoordinate2D(
      latitude: (minLat + maxLat) / 2,
      longitude: (minLon + maxLon) / 2
    )
    
    let span = MKCoordinateSpan(
      latitudeDelta: (maxLat - minLat) * 1.5,
      longitudeDelta: (maxLon - minLon) * 1.5
    )
    
    mapRegion = MKCoordinateRegion(center: center, span: span)
  }
  
  private func clearExistingData() {
    do {
      try modelContext.delete(model: Season.self)
      try modelContext.delete(model: Episode.self)
      try modelContext.delete(model: Location.self)
    } catch {
      handleError(error: error, message: "Failed to clear existing data")
    }
  }
  
  private func loadSeasonFromJSON(seasonNumber: Int) {
    let filename = "season\(seasonNumber)"
    
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
      print("Could not find \(filename).json")
      return
    }
    
    do {
      let data = try Data(contentsOf: url)
      let seasonData = try JSONDecoder().decode(SeasonData.self, from: data)
      
      let season = Season(
        seasonAirDate: seasonData.seasonAirDate,
        title: seasonData.title,
        totalEpisodes: seasonData.totalEpisodes,
        seasonNumber: seasonData.seasonNumber
      )
      modelContext.insert(season)
      
      for episodeData in seasonData.episodes {
        let episode = createEpisode(from: episodeData, in: season)
        createLocations(from: episodeData.locations, in: episode)
      }
      
    } catch {
      handleError(error: error, message: "Failed to load \(filename).json")
    }
  }
  
  private func createEpisode(from data: EpisodeData, in season: Season) -> Episode {
    let episode = Episode(
      episodeAirDate: data.episodeAirDate,
      episodeDescription: data.episodeDescription,
      episodeGuestStars: data.episodeGuestStars,
      episodeNumber: data.episodeNumber,
      episodeTitle: data.episodeTitle,
      seasonEpisodeNumber: data.seasonEpisodeNumber
    )
    episode.season = season
    modelContext.insert(episode)
    return episode
  }
  
  private func createLocations(from locationDataArray: [LocationData], in episode: Episode) {
    for locationData in locationDataArray {
      let imageData = loadImageData(filename: locationData.imageFilename)
      
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
  
  private func loadImageData(filename: String) -> Data? {
    guard let url = Bundle.main.url(forResource: filename.components(separatedBy: ".").first,
                                    withExtension: filename.components(separatedBy: ".").last) else {
      print("Could not find image: \(filename)")
      return nil
    }
    return try? Data(contentsOf: url)
  }
  
  // MARK: - Error Handling
  private func handleError(error: Error, message: String) {
    errorMessage = "\(message): \(error.localizedDescription)"
    showError = true
    print(errorMessage)
  }
}
