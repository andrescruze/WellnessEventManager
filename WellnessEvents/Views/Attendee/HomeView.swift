import SwiftUI

struct HomeView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(EventsViewModel.self) private var eventsViewModel
    @State private var selectedCategory: EventCategory? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBeige.ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        // Greeting header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(greetingText)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(authViewModel.currentUser?.name.components(separatedBy: " ").first ?? "Friend")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.appDarkText)
                            }
                            Spacer()
                            ZStack {
                                Circle().fill(Color.appMint.opacity(0.3)).frame(width: 46, height: 46)
                                Image(systemName: "figure.yoga")
                                    .font(.title3)
                                    .foregroundStyle(Color(hex: "1E5631"))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)

                        // Featured event banner
                        if let featured = eventsViewModel.events.max(by: { $0.attendeeCount < $1.attendeeCount }) {
                            FeaturedEventBanner(event: featured)
                                .padding(.horizontal)
                        }

                        // Category filter
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Browse by Category")
                                .font(.headline)
                                .foregroundStyle(Color.appDarkText)
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    CategoryFilterChip(
                                        label: "All",
                                        icon: "square.grid.2x2",
                                        isSelected: selectedCategory == nil
                                    ) {
                                        withAnimation { selectedCategory = nil }
                                    }
                                    ForEach(EventCategory.allCases) { cat in
                                        CategoryFilterChip(
                                            label: cat.rawValue,
                                            icon: cat.icon,
                                            isSelected: selectedCategory == cat
                                        ) {
                                            withAnimation {
                                                selectedCategory = selectedCategory == cat ? nil : cat
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            }
                        }

                        // Events list
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(selectedCategory == nil ? "Upcoming Events" : "\(selectedCategory!.rawValue) Events")
                                    .font(.headline)
                                    .foregroundStyle(Color.appDarkText)
                                Spacer()
                                Text("\(displayedEvents.count) events")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal)

                            if displayedEvents.isEmpty {
                                EmptyStateView(
                                    icon: "leaf",
                                    title: "No events found",
                                    subtitle: "Check back soon — new wellness experiences are being added regularly."
                                )
                                .padding(.horizontal)
                            } else {
                                ForEach(displayedEvents) { event in
                                    NavigationLink(destination: EventDetailView(event: event)) {
                                        EventCardView(event: event)
                                            .padding(.horizontal)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.bottom, 24)
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                .refreshable {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                }
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var displayedEvents: [WellnessEvent] {
        let base = eventsViewModel.events
            .filter { $0.date > Date() }
            .sorted { $0.date < $1.date }
        if let cat = selectedCategory {
            return base.filter { $0.category == cat }
        }
        return base
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good morning,"
        case 12..<17: return "Good afternoon,"
        default: return "Good evening,"
        }
    }
}

private struct FeaturedEventBanner: View {
    let event: WellnessEvent

    var body: some View {
        NavigationLink(destination: EventDetailView(event: event)) {
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    colors: [Color.appBlue.opacity(0.8), Color.appMint.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 180)

                Image(systemName: event.imageName)
                    .font(.system(size: 80))
                    .foregroundStyle(.white.opacity(0.25))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 20)

                VStack(alignment: .leading, spacing: 6) {
                    Text("FEATURED")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.8))
                        .tracking(2)

                    Text(event.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    HStack(spacing: 12) {
                        Label(event.date.formatted(.dateTime.month().day()), systemImage: "calendar")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.9))
                        Label(event.location.components(separatedBy: ",").first ?? "", systemImage: "mappin")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                }
                .padding(16)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: Color.appBlue.opacity(0.3), radius: 10, y: 5)
        }
        .buttonStyle(.plain)
    }
}

private struct CategoryFilterChip: View {
    let label: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: icon).font(.caption)
                Text(label).font(.caption).fontWeight(.medium)
            }
            .foregroundStyle(isSelected ? Color(hex: "1E5631") : Color.secondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color.appMint : Color.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.05), radius: 4)
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 44))
                .foregroundStyle(Color.appMint)
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.appDarkText)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HomeView()
        .environment(AuthViewModel())
        .environment(EventsViewModel())
}
