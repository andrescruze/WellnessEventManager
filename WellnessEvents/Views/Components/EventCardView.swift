import SwiftUI

struct EventCardView: View {
    let event: WellnessEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Hero image area
            ZStack(alignment: .topLeading) {
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 150)

                Image(systemName: event.imageName)
                    .font(.system(size: 56))
                    .foregroundStyle(.white.opacity(0.5))
                    .frame(maxWidth: .infinity, minHeight: 150)

                VStack {
                    HStack {
                        CategoryBadge(category: event.category, small: true)
                        Spacer()
                        if event.isSoldOut {
                            Text("Sold Out")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.black.opacity(0.5))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(10)
                    Spacer()
                }
            }
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 16, bottomLeadingRadius: 0,
                bottomTrailingRadius: 0, topTrailingRadius: 16
            ))

            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(event.title)
                    .font(.headline)
                    .foregroundStyle(Color.appDarkText)
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .font(.caption)
                        .foregroundStyle(Color.appBlue)
                    Text(event.organizerName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 12) {
                    Label {
                        Text(event.date, style: .date)
                            .font(.caption)
                    } icon: {
                        Image(systemName: "calendar")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)

                    Label {
                        Text(event.location.components(separatedBy: ",").first ?? event.location)
                            .font(.caption)
                            .lineLimit(1)
                    } icon: {
                        Image(systemName: "mappin")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }

                HStack {
                    Text(event.formattedPrice)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.appDarkText)

                    Spacer()

                    if !event.isSoldOut {
                        Text("Book Now")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(Color.appMint)
                            .clipShape(Capsule())
                    } else {
                        Text("\(event.availableSpots) spots left")
                            .font(.caption)
                            .foregroundStyle(Color(hex: "E07B39"))
                    }
                }
            }
            .padding(14)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
    }

    private var gradientColors: [Color] {
        switch event.category {
        case .yoga: return [Color.appMint.opacity(0.7), Color.appBlue.opacity(0.4)]
        case .meditation: return [Color.appLavender.opacity(0.7), Color.appBlue.opacity(0.4)]
        case .soundBath: return [Color.appBlue.opacity(0.6), Color.appLavender.opacity(0.5)]
        case .retreat: return [Color.appMint.opacity(0.6), Color(hex: "2E8B57").opacity(0.4)]
        case .workshop: return [Color.appLavender.opacity(0.6), Color.appMint.opacity(0.4)]
        case .other: return [Color.appGray.opacity(0.7), Color.appBlue.opacity(0.3)]
        }
    }
}

#Preview {
    EventCardView(event: MockData.sampleEvents[0])
        .padding()
        .background(Color.appBeige)
}
