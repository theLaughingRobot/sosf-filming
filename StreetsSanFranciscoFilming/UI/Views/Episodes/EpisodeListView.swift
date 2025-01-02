import SwiftUI
import SwiftData

struct EpisodeListView: View {
  @ObservedObject var filmingVM: FilmingViewModel
  let season: Season
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .topLeading){
        EpisodeContent(filmingVM: filmingVM, season: season)
        EpisodeHeader(filmingVM: filmingVM, season: season)
      }
      .background(Color(UIColor.secondarySystemBackground))
      .edgesIgnoringSafeArea(.horizontal)
    }
  }
}

struct EpisodeHeader: View {
  @ObservedObject var filmingVM: FilmingViewModel
  let season: Season
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    ZStack(alignment: .top) {
      HeaderGradient(gradientColor: filmingVM.getColorFromSeason(season: season))
      
      ZStack(alignment: .center) {
        Text("Episodes")
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
    
struct EpisodeContent: View {
  @ObservedObject var filmingVM: FilmingViewModel
  let season: Season
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 0) {
        ForEach(filmingVM.loadEpisodesForSeason(season)) { episode in
          NavigationLink(destination: LocationListView(filmingVM: filmingVM, episode: episode)) {
            EpisodeCard(filmingVM: filmingVM, episode: episode)
              .padding(.top, 16)
          }
          .buttonStyle(PlainButtonStyle())
        }
      }
      .padding(.bottom, 48)
      .padding(.top, Constants.Sizes.headerHeight)
      .navigationBarHidden(true)
    }
    .ignoresSafeArea(edges: .top)
  }
}

struct EpisodeCard: View {
  @ObservedObject var filmingVM: FilmingViewModel
  var episode: Episode
  
  var body: some View {
    VStack {
      HStack(alignment: .top) {
        Rectangle()
          .foregroundStyle(filmingVM.getColorFromEpisode(episode: episode))
          .frame(width: 16)
        VStack(alignment: .leading, spacing: 0) {
          if episode.episodeNumber == 0 {
            Text("\(episode.episodeTitle)")
              .font(Font.custom(Constants.FontNames.HelveticaNeueBold, size: 16))
              .foregroundStyle(.black)
          } else {
            Text("Episode \(episode.episodeNumber): \(episode.episodeTitle)")
              .font(Font.custom(Constants.FontNames.HelveticaNeueBold, size: 16))
              .foregroundStyle(.black)
          }
          Spacer()
            .frame(height: 24)
          
          Text("Airdate : \(episode.episodeAirDate)")
            .font(Font.custom(Constants.FontNames.HelveticaNeueLight, size: 12))
            .foregroundStyle(.gray500)
        }
        .padding(.top, 12)
        .padding(.bottom, 14)
        .padding(.leading, 8)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.white)
    .cornerRadius(8)
    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 2)
    .padding(.horizontal, Constants.Sizes.horizontalPadding)
  }
}
