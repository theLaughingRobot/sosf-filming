import Kingfisher
import MapKit
import SwiftUI

struct LocationDetailView: View {
  @ObservedObject var filmingVM: FilmingViewModel
  var location: Location
  
  @Environment(\.presentationMode) private var presentationMode
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Spacer()
        Button(action: {
          presentationMode.wrappedValue.dismiss()
        }) {
          Image(systemName: "xmark")
            .font(.subheadline)
            .foregroundColor(.black)
        }
        .padding()
      }
      
      DetailCard(filmingVM: filmingVM, location: location)
      Spacer()
    }
    .padding(.horizontal, Constants.Sizes.horizontalPadding)
    .padding(.top, Constants.Sizes.horizontalPadding)
  }
}

struct DetailCard: View {
  @ObservedObject var filmingVM: FilmingViewModel
  let location: Location
  
  var body: some View {
    let episode = filmingVM.getEpisodeForLocation(location)
    let season = filmingVM.getSeasonForLocation(location)
    
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 4){
        HStack {
          Text("Season \(season?.seasonNumber ?? 0)")
          Text("Episode \(episode?.episodeNumber ?? 0)")
        }
        .font(.title2)
        .fontWeight(.bold)
        
        HStack {
          Text("Episode Title:")
            .font(.headline)
          Text("\(episode?.episodeTitle ?? "")")
            .font(.subheadline)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.bottom, 12)
      
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text("Air Date:")
            .font(.headline)
          Text("\(episode?.episodeAirDate ?? "")")
            .font(.subheadline)
        }
        
        HStack {
          Text("Timecode:")
            .font(.headline)
          Text("\(location.timeCode)")
            .font(.subheadline)
        }
        
        HStack(alignment: .top) {
          Text("Location:")
            .font(.headline)
          Text("\(location.locationTitle)")
            .font(.subheadline)
        }
        
        HStack(alignment: .top) {
          Text("Description:")
            .font(.headline)
          Text("\(location.locationInfo)")
            .font(.subheadline)
        }
        .padding(.bottom, 24)
        
        VStack(spacing: 20) {
          HStack {
            Text("Satellite View")
              .font(.headline)
            Spacer()
          }
          
          DetailMapView(latitude: location.filmingLocation.latitude,
                        longitude: location.filmingLocation.longitude)
            .frame(height: 300)
            .cornerRadius(10)
            .padding(.bottom, 24)
          
          if let imageFilename = location.imageFilename, !imageFilename.isEmpty {
            HStack {
              Text("Episode View")
                .font(.headline)
              Spacer()
            }
            DetailLocationImage(imageFilename: imageFilename)
              .padding(.bottom, 24)
          }
          
          HStack {
            Text("Current Street View")
              .font(.headline)
            Spacer()
          }
          
          LookAroundPreview(coordinate: CLLocationCoordinate2D(
            latitude: location.filmingLocation.latitude,
            longitude: location.filmingLocation.longitude
          ))
          .frame(maxWidth: .infinity)
          .cornerRadius(8)
          .padding(.bottom, 24)
        }
      }
    }
    .ignoresSafeArea(edges: .top)
  }
}

struct DetailLocationImage: View {
  var imageFilename: String

  var body: some View {
    if let url = URL(string: imageFilename) {
      KFImage(url)
        .placeholder {
          ZStack {
            Rectangle()
              .foregroundStyle(.clear)
              .frame(maxWidth: .infinity)
            VStack {
              Spacer()
              ProgressView()
              Spacer()
            }
          }
        }
        .onFailure { error in
          print("Detail image loading failed: \(error.localizedDescription)")
        }
        .cacheOriginalImage()
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .cornerRadius(8)
        .clipped()
    } else {
      //FallBackImage(isDetailView: true)
    }
  }
}

struct DetailMapView: View {
  let latitude: Double
  let longitude: Double
  
  @State private var region: MKCoordinateRegion
  
  init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
    _region = State(initialValue: MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
      span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
    ))
  }
  
  var body: some View {
    Map(coordinateRegion: $region,
        annotationItems: [MapMarkerItem(latitude: latitude, longitude: longitude)]
    ) { item in
      MapMarker(coordinate: item.coordinate, tint: .red)
    }
    .allowsHitTesting(false)
    .mapStyle(.hybrid)
  }
}

struct MapMarkerItem: Identifiable {
  let id = UUID()
  let latitude: Double
  let longitude: Double
  
  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}
