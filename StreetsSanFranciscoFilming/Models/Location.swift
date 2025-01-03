import Foundation
import SwiftData
import CoreLocation

@Model
final class Location {
  var locationInfo: String
  var filmingLocation: Coordinate
  var imageFilename: String?
  var locationTitle: String
  var timeCode: String
  
  @Relationship(inverse: \Episode.locations) var episode: Episode?
  
  init(locationInfo: String, filmingLocation: Coordinate, imageFilename: String?, locationTitle: String, timeCode: String) {
    self.locationInfo = locationInfo
    self.filmingLocation = filmingLocation
    self.imageFilename = imageFilename ?? "sosf-1.jpg"
    self.locationTitle = locationTitle
    self.timeCode = timeCode
  }
}
