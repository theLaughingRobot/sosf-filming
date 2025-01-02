import SwiftUI

enum FilteredSeasons: String {
  case allSeasons = "All Seasons"
  case season1 = "Season One"
  case season2 = "Season Two"
  case season3 = "Season Three"
  case season4 = "Season Four"
  case season5 = "Season Five"
}

struct Constants {
  struct UserInfoParam {
    static let userName = "user_name"
    static let userID = "user_id"
  }
  
  struct API {
    static let api1 = "api1"
    static let api2 = "api2"
  }
  
  struct AlertMessages {
    static let NoDataFound = "No Data Found."
    static let InternetError = "Check internet connection."
  }
  
  struct Sizes {
    static let headerHeight = 120.0
    static let horizontalPadding = 12.0
  }
  
  struct FontNames {
    
    static let HelveticaNeue = "HelveticaNeue"
    static let HelveticaNeueBold = "HelveticaNeue-Bold"
    static let HelveticaNeueLight = "HelveticaNeue-Light"
  }
  
  static let LocationRecord = "Location"
  static let EpisodeRecord = "Episode"
  static let SeasonRecord = "Season"
}

struct DeviceMetrics {
  static var screenWidth: CGFloat {
    UIScreen.main.bounds.width
  }
  
  static var screenHeight: CGFloat {
    UIScreen.main.bounds.height
  }
  
  static var screenWidthPadding: CGFloat {
    UIScreen.main.bounds.width - (2 * Constants.Sizes.horizontalPadding)
  }
}
