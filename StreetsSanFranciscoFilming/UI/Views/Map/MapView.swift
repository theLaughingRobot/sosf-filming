import SwiftUI
import MapKit

struct MapView: View {
  @ObservedObject var filmingVM: FilmingViewModel
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .top) {
        Map(coordinateRegion: $filmingVM.mapRegion, annotationItems: filmingVM.locationsToShow) { location in
          MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.filmingLocation.latitude, longitude: location.filmingLocation.longitude)) {
            CustomMapMarker(
              coordinate: CLLocationCoordinate2D(latitude: location.filmingLocation.latitude, longitude: location.filmingLocation.longitude),
              title: location.locationTitle,
              tintColor: filmingVM.getPinColorFromSeason()
            )
            .onTapGesture {
              filmingVM.selectedLocation = location
              filmingVM.isSheetPresented = true
            }
          }
        }
        
        VStack(alignment: .leading) {
          HStack {
            SeasonFilter(filmingVM: filmingVM)
            if filmingVM.selectedSeason != nil {
              EpisodeFilter(filmingVM: filmingVM)
                .onChange(of: filmingVM.selectedSeason) {
                  filmingVM.selectedEpisode = nil
                }
            }
            
            Spacer()
          }
          .padding(.leading, Constants.Sizes.horizontalPadding)
          
          Spacer()
          
          HStack {
            Spacer()
            Text(filmingVM.getLocationLabel())
              .font(Font.custom(Constants.FontNames.HelveticaNeueBold, size: 18))
              .padding(.vertical, 12)
              .padding(.horizontal, 24)
              .background(.ultraThinMaterial)
            Spacer()
          }
        }
        .ignoresSafeArea(edges: [.bottom, .top])
        .padding(.top, 60)
        .padding(.bottom, 30)
        
        MapHeader(filmingVM: filmingVM)
      }
      .navigationBarHidden(true)
    }
    .sheet(item: $filmingVM.selectedLocation) { location in
      LocationDetailView(filmingVM: filmingVM, location: location)
    }
    .onAppear {
      filmingVM.fitMapToLocations(filmingVM.locationsToShow)
    }
  }
}

struct SeasonFilter: View {
  @ObservedObject var filmingVM: FilmingViewModel
  
  var body: some View {
    Menu {
      Button("All Seasons") {
        filmingVM.selectedSeason = nil
        filmingVM.fitMapToLocations(filmingVM.locationsToShow)
      }
      
      Divider()
      ForEach(filmingVM.seasons) { season in
        Button(season.title) {
          filmingVM.selectedSeason = season
          filmingVM.fitMapToLocations(filmingVM.getLocationsForSeason(season))
        }
      }
    } label: {
      HStack(spacing: 4) {
        Text(filmingVM.seasonToShow)
          .font(Font.custom(Constants.FontNames.HelveticaNeueBold, size: 18))
        Image(systemName: "chevron.down")
          .fontWeight(.bold)
      }
      .padding(.vertical, 12)
      .padding(.horizontal, 24)
      .background(.ultraThinMaterial)
    }
    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 2)
    .border(.gray300)
  }
}

struct EpisodeFilter: View {
  @ObservedObject var filmingVM: FilmingViewModel
  
  var body: some View {
    Menu {
      Button("All Episodes") {
        filmingVM.selectedEpisode = nil
        filmingVM.fitMapToLocations(filmingVM.locationsToShow)
      }
      
      Divider()
      if let selectedSeason = filmingVM.selectedSeason {
        ForEach(filmingVM.loadEpisodesForSeason(selectedSeason)) { episode in
          Button("Ep: \(episode.episodeNumber) - \(episode.episodeTitle)") {
            filmingVM.selectedEpisode = episode
            filmingVM.fitMapToLocations(filmingVM.locationsToShow)
          }
        }
      }
    } label: {
      HStack(spacing: 4) {
        Text(filmingVM.episodeToShow)
          .font(Font.custom(Constants.FontNames.HelveticaNeueBold, size: 18))
        Image(systemName: "chevron.down")
          .fontWeight(.bold)
      }
      .padding(.vertical, 12)
      .padding(.horizontal, 24)
      .background(.ultraThinMaterial)
    }
    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 2)
    .border(.gray300)
  }
}

struct MapHeader: View {
  @ObservedObject var filmingVM: FilmingViewModel
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    ZStack(alignment: .top) {
      HeaderGradient(gradientColor: filmingVM.getColorFromMapSeason())
      
      ZStack(alignment: .center) {
        Text("Filming Locations")
          .font(Font.custom(Constants.FontNames.HelveticaNeueBold, size: 28))
          .foregroundStyle(Color.white)
          .lineLimit(1)
      }
      .padding(.horizontal, Constants.Sizes.horizontalPadding)
    }
  }
}

struct CustomMapMarker: View {
  let coordinate: CLLocationCoordinate2D
  let title: String
  let tintColor: Color
  
  var body: some View {
    VStack(spacing: 0) {
      ZStack {
        Circle()
          .fill(tintColor)
          .frame(width: 33, height: 33)
          .shadow(radius: 3)
        
        Image(systemName: "star.fill")
          .foregroundColor(.white)
      }
      
      Image(systemName: "triangle.fill")
        .rotationEffect(.degrees(180))
        .foregroundColor(tintColor)
        .offset(y: -6)
      
      if !title.isEmpty {
        Text(title)
          .font(.caption)
          .fontWeight(.bold)
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .fill(Color.white)
              .shadow(radius: 2)
          )
          .offset(y: -3)
      }
    }
  }
}
