import SwiftUI

struct MainTabView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var selectedTab: Int = 0

    var isOrganizer: Bool {
        authViewModel.currentUser?.role == .organizer
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            if isOrganizer {
                // Organizer: Dashboard + Profile
                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: selectedTab == 0 ? "chart.bar.fill" : "chart.bar")
                    }
                    .tag(0)

                OrganizerEventsTab()
                    .tabItem {
                        Label("Events", systemImage: selectedTab == 1 ? "calendar.circle.fill" : "calendar.circle")
                    }
                    .tag(1)

                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: selectedTab == 2 ? "person.fill" : "person")
                    }
                    .tag(2)

            } else {
                // Attendee: Home + Search + Tickets + Profile
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                    }
                    .tag(0)

                SearchView()
                    .tabItem {
                        Label("Search", systemImage: selectedTab == 1 ? "magnifyingglass.circle.fill" : "magnifyingglass")
                    }
                    .tag(1)

                MyTicketsView()
                    .tabItem {
                        Label("Tickets", systemImage: selectedTab == 2 ? "ticket.fill" : "ticket")
                    }
                    .tag(2)

                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: selectedTab == 3 ? "person.fill" : "person")
                    }
                    .tag(3)
            }
        }
        .tint(Color.appBlue)
        .onAppear {
            #if os(iOS)
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.appBeige)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            #endif
        }
    }
}

/// A full-screen browse view for organizers to see all marketplace events.
private struct OrganizerEventsTab: View {
    @Environment(EventsViewModel.self) private var eventsViewModel
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var showCreateEvent = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBeige.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Marketplace Events")
                            .font(.headline)
                            .foregroundStyle(Color.appDarkText)
                            .padding(.horizontal)
                            .padding(.top, 16)

                        ForEach(eventsViewModel.events.sorted { $0.date < $1.date }) { event in
                            NavigationLink(destination: EventDetailView(event: event)) {
                                EventCardView(event: event)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.plain)
                        }

                        Color.clear.frame(height: 20)
                    }
                }
            }
            .navigationTitle("Browse Events")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCreateEvent = true
                    } label: {
                        Label("Create", systemImage: "plus.circle.fill")
                            .foregroundStyle(Color.appBlue)
                    }
                }
            }
            .sheet(isPresented: $showCreateEvent) {
                CreateEventView()
            }
        }
    }
}

#Preview {
    MainTabView()
        .environment(AuthViewModel())
        .environment(EventsViewModel())
        .environment(TicketsViewModel())
}
