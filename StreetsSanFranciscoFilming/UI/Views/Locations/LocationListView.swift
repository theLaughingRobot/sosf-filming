import Kingfisher
import SwiftUI

struct LocationListView: View {
  @ObservedObject var filmingVM: FilmingViewModel
  var episode: Episode
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .topLeading){
        LocationContent(filmingVM: filmingVM,
                        episode: episode)
        LocationHeader(filmingVM: filmingVM,
                       episode: episode)
      }
      .background(Color(UIColor.secondarySystemBackground))
      .edgesIgnoringSafeArea(.horizontal)
    }
  }
}

struct LocationHeader: View {
  @ObservedObject var filmingVM: FilmingViewModel
  let episode: Episode
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    ZStack(alignment: .top) {
      HeaderGradient(gradientColor: filmingVM.getColorFromEpisode(episode: episode))
      
      ZStack(alignment: .center) {
        Text("Filming Location")
          .font(Font.custom(Constants.FontNames.HelveticaNeueBold, size: 28))
          .foregroundStyle(Color.white)
          .lineLimit(1)
        
        HStack {
          Button(action: {
            dismiss()
          }) {
            Image(systemName: "chevron.left")
              .fontWeight(.bold)
              .font(.system(size: 24))
              .foregroundStyle(.white)
          }
          Spacer()
        }
      }
      .padding(.horizontal, Constants.Sizes.horizontalPadding)
    }
  }
}

struct LocationContent: View {
  @ObservedObject var filmingVM: FilmingViewModel
  let episode: Episode
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 0) {
        ForEach(filmingVM.loadLocationsForEpisode(episode)) { location in
          LocationCard(filmingVM: filmingVM, location: location)
            .padding(.top, 16)
            .onTapGesture {
              filmingVM.selectedLocation = location
              filmingVM.isSheetPresented = true
            }
        }
      }
      .padding(.bottom, 48)
      .padding(.top, Constants.Sizes.headerHeight)
      .navigationBarHidden(true)
    }
    .ignoresSafeArea(edges: .top)
    .sheet(isPresented: $filmingVM.isSheetPresented) {
      if let location = filmingVM.selectedLocation {
        LocationDetailView(filmingVM: filmingVM, location: location)
      }
    }
  }
}

struct LocationCard: View {
  @ObservedObject var filmingVM: FilmingViewModel
  var location: Location
  
  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      LocationImage(imageFilename: location.imageFilename ?? "")
      VStack(alignment: .leading, spacing: 0) {
        Text(location.locationTitle)
          .font(Font.custom(Constants.FontNames.HelveticaNeueBold, size: 18))
          .foregroundStyle(.black)
        
        Text(location.locationInfo)
          .font(Font.custom(Constants.FontNames.HelveticaNeueLight, size: 12))
          .foregroundStyle(.black)
        
        Spacer()
        
        Text("time code : \(location.timeCode)")
          .font(Font.custom(Constants.FontNames.HelveticaNeueLight, size: 12))
          .foregroundStyle(Color.gray500)
      }
      .padding(.horizontal, 8)
      .padding(.vertical, 8)
    }
    .frame(maxWidth: .infinity, minHeight: 112, alignment: .leading)
    .background(Color.white)
    .cornerRadius(8)
    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 2)
    .padding(.horizontal, Constants.Sizes.horizontalPadding)
  }
}

struct LocationImage: View {
  var imageFilename: String
  
  var body: some View {
    if let url = URL(string: imageFilename) {
      KFImage(url)
        .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 300, height: 300)))
        .fade(duration: 0.25)
        .placeholder { _ in
          ZStack {
            Rectangle()
              .foregroundStyle(.clear)
              .frame(width: DeviceMetrics.screenWidthPadding * 0.3,
                     height: DeviceMetrics.screenWidthPadding * 0.3)
            VStack {
              Spacer()
              ProgressView()
              Spacer()
            }
          }
        }
        .onFailure { error in
          print("Image loading failed: \(error.localizedDescription)")
        }
        .cacheOriginalImage()
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(maxWidth: UIScreen.main.bounds.width * 0.3 - 24)
        .clipped()
    }
    else {
      FallBackImage()
    }
  }
}

struct FallBackImage: View {
  var isDetailView = false
  
  var body: some View {
    Image("sosf-1")
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(maxWidth: (UIScreen.main.bounds.width * (isDetailView ? 1.0 : 0.3)) - 24)
//      .cornerRadius(8.0)
      .clipped()
  }
}
