import SwiftUI
import SwiftData

struct SeasonListView: View {
  @ObservedObject var filmingVM: FilmingViewModel
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .topLeading){
        SeasonContent(filmingVM: filmingVM)
        SeasonHeader()
      }
      .background(Color(UIColor.secondarySystemBackground))
      .edgesIgnoringSafeArea(.horizontal)
    }
  }
}

struct SeasonContent: View {
  @ObservedObject var filmingVM: FilmingViewModel
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 0) {
        ForEach(filmingVM.seasons, id: \.self) { season in
          NavigationLink(
            destination: EpisodeListView(filmingVM: filmingVM, season: season)
          ) {
            SeasonCard(filmingVM: filmingVM, season: season)
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

struct SeasonHeader: View {
  var body: some View {
    ZStack(alignment: .top) {
      HeaderGradient()
      Text("SOSF Seasons")
        .font(Font.custom(Constants.FontNames.HelveticaNeueBold, size: 28))
        .foregroundStyle(Color.white)
    }
  }
}

struct SeasonCard: View {
  @ObservedObject var filmingVM: FilmingViewModel
  var season: Season
  
  var body: some View {
    VStack {
      HStack(alignment: .top) {
        Rectangle()
          .foregroundStyle(filmingVM.getColorFromSeason(season: season))
          .frame(width: 16)
        VStack(alignment: .leading, spacing: 0) {
          Text(season.title)
            .font(Font.custom(Constants.FontNames.HelveticaNeueBold, size: 40))
            .foregroundStyle(.black)
          
          Text(season.seasonAirDate)
            .font(Font.custom(Constants.FontNames.HelveticaNeueLight, size: 18))
            .foregroundStyle(.black)
          
          Spacer()
            .frame(height: 24)
          
          Text("Total Episodes: \(season.totalEpisodes)")
            .font(Font.custom(Constants.FontNames.HelveticaNeueLight, size: 18))
            .foregroundStyle(.gray)
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
