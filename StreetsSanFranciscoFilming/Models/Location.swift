import Foundation
import SwiftData
import CoreLocation

@Model
final class Location {
  var locationInfo: String
  var filmingLocation: Coordinate
  var locationImage: Data?
  var locationTitle: String
  var timeCode: String
  
  @Relationship(inverse: \Episode.locations) var episode: Episode?
  
  init(locationInfo: String, filmingLocation: Coordinate, locationImage: Data? = nil, locationTitle: String, timeCode: String) {
    self.locationInfo = locationInfo
    self.filmingLocation = filmingLocation
    self.locationImage = locationImage
    self.locationTitle = locationTitle
    self.timeCode = timeCode
  }
}
