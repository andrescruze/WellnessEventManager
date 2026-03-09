import SwiftUI
import MapKit

struct EventDetailView: View {
    let event: WellnessEvent
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var showPurchase = false
    @State private var mapPosition: MapCameraPosition

    init(event: WellnessEvent) {
        self.event = event
        _mapPosition = State(initialValue: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.appBeige.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero
                    ZStack(alignment: .bottomLeading) {
                        LinearGradient(
                            colors: heroGradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 260)

                        Image(systemName: event.imageName)
                            .font(.system(size: 100))
                            .foregroundStyle(.white.opacity(0.25))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 24)

                        VStack(alignment: .leading, spacing: 8) {
                            CategoryBadge(category: event.category)
                            Text(event.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .shadow(radius: 4)
                        }
                        .padding(20)
                    }

                    VStack(alignment: .leading, spacing: 24) {
                        // Quick info row
                        HStack(spacing: 0) {
                            QuickInfoItem(icon: "calendar", label: "Date", value: event.date.formatted(.dateTime.month().day().year()))
                            Divider().frame(height: 40)
                            QuickInfoItem(icon: "clock", label: "Time", value: event.date.formatted(.dateTime.hour().minute()))
                            Divider().frame(height: 40)
                            QuickInfoItem(icon: "person.2.fill", label: "Spots", value: "\(event.availableSpots) left")
                        }
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: .black.opacity(0.05), radius: 8)

                        // Organizer
                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader(title: "Organized by", icon: "person.circle")
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle().fill(Color.appLavender.opacity(0.3)).frame(width: 48, height: 48)
                                    Text(String(event.organizerName.prefix(1)))
                                        .font(.title3).fontWeight(.bold)
                                        .foregroundStyle(Color(hex: "4A148C"))
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(event.organizerName)
                                        .font(.subheadline).fontWeight(.semibold)
                                        .foregroundStyle(Color.appDarkText)
                                    Text(event.organizerBio)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                }
                            }
                            .padding(14)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        // About
                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader(title: "About this event", icon: "doc.text")
                            Text(event.description)
                                .font(.body)
                                .foregroundStyle(Color(hex: "2C3E50"))
                                .lineSpacing(4)
                        }

                        // Schedule
                        if !event.schedule.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                SectionHeader(title: "Schedule", icon: "list.bullet.clipboard")
                                VStack(spacing: 0) {
                                    ForEach(Array(event.schedule.enumerated()), id: \.element.id) { idx, item in
                                        HStack(alignment: .top, spacing: 14) {
                                            VStack(spacing: 0) {
                                                Circle()
                                                    .fill(Color.appMint)
                                                    .frame(width: 10, height: 10)
                                                    .padding(.top, 4)
                                                if idx < event.schedule.count - 1 {
                                                    Rectangle()
                                                        .fill(Color.appGray)
                                                        .frame(width: 1.5)
                                                        .frame(maxHeight: .infinity)
                                                }
                                            }
                                            VStack(alignment: .leading, spacing: 3) {
                                                Text(item.time)
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(Color.appBlue)
                                                Text(item.activity)
                                                    .font(.subheadline)
                                                    .foregroundStyle(Color.appDarkText)
                                            }
                                            .padding(.bottom, idx < event.schedule.count - 1 ? 16 : 0)
                                        }
                                    }
                                }
                                .padding(16)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }

                        // Location
                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader(title: "Location", icon: "mappin.circle")
                            HStack(spacing: 6) {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundStyle(Color.appBlue)
                                Text(event.location)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.appDarkText)
                            }

                            if event.latitude != 0 {
                                Map(position: $mapPosition) {
                                    Marker(event.title, coordinate: CLLocationCoordinate2D(
                                        latitude: event.latitude,
                                        longitude: event.longitude
                                    ))
                                    .tint(Color.appMint)
                                }
                                .frame(height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .disabled(true)
                            }
                        }

                        // Spacer for bottom bar
                        Color.clear.frame(height: 90)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                }
            }
            .ignoresSafeArea(edges: .top)

            // Sticky purchase bar
            VStack(spacing: 0) {
                Divider()
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Price per ticket")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(event.formattedPrice)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.appDarkText)
                    }
                    Spacer()
                    Button {
                        showPurchase = true
                    } label: {
                        Text(event.isSoldOut ? "Sold Out" : "Purchase Tickets")
                            .fontWeight(.semibold)
                            .foregroundStyle(event.isSoldOut ? Color.secondary : Color(hex: "1E5631"))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 14)
                            .background(event.isSoldOut ? Color.appGray : Color.appMint)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: event.isSoldOut ? .clear : Color.appMint.opacity(0.4), radius: 6, y: 3)
                    }
                    .disabled(event.isSoldOut)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(Color.appBeige)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPurchase) {
            PurchaseView(event: event)
        }
    }

    private var heroGradient: [Color] {
        switch event.category {
        case .yoga: return [Color.appMint.opacity(0.8), Color.appBlue.opacity(0.5)]
        case .meditation: return [Color.appLavender.opacity(0.8), Color.appBlue.opacity(0.5)]
        case .soundBath: return [Color.appBlue.opacity(0.7), Color.appLavender.opacity(0.6)]
        case .retreat: return [Color.appMint.opacity(0.7), Color(hex: "2E8B57").opacity(0.5)]
        case .workshop: return [Color.appLavender.opacity(0.7), Color.appMint.opacity(0.5)]
        case .other: return [Color.appBlue.opacity(0.6), Color.appGray.opacity(0.5)]
        }
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(Color.appBlue)
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.appBlue)
        }
    }
}

private struct QuickInfoItem: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(Color.appMint)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color.appDarkText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        EventDetailView(event: MockData.sampleEvents[0])
            .environment(AuthViewModel())
            .environment(EventsViewModel())
    }
}
