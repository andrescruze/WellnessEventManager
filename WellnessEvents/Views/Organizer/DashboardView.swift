import SwiftUI

struct DashboardView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(EventsViewModel.self) private var eventsViewModel
    @State private var showCreateEvent = false
    @State private var eventToEdit: WellnessEvent? = nil
    @State private var attendeeEvent: WellnessEvent? = nil
    @State private var showDeleteAlert = false
    @State private var eventToDelete: WellnessEvent? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBeige.ignoresSafeArea()

                let userId = authViewModel.currentUser?.id ?? ""
                let myEvents = eventsViewModel.events(for: userId)

                ScrollView {
                    VStack(spacing: 20) {
                        // Stats row
                        HStack(spacing: 12) {
                            StatCard(
                                icon: "calendar",
                                value: "\(myEvents.count)",
                                label: "Events",
                                color: Color.appBlue
                            )
                            StatCard(
                                icon: "person.2.fill",
                                value: "\(eventsViewModel.totalAttendees(for: userId))",
                                label: "Attendees",
                                color: Color.appMint
                            )
                            StatCard(
                                icon: "dollarsign.circle.fill",
                                value: String(format: "$%.0f", eventsViewModel.totalRevenue(for: userId)),
                                label: "Revenue",
                                color: Color.appLavender
                            )
                        }
                        .padding(.horizontal)

                        // Events list
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("Your Events")
                                    .font(.headline)
                                    .foregroundStyle(Color.appDarkText)
                                Spacer()
                                Button {
                                    showCreateEvent = true
                                } label: {
                                    Label("New Event", systemImage: "plus")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color(hex: "1E5631"))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 7)
                                        .background(Color.appMint)
                                        .clipShape(Capsule())
                                }
                            }
                            .padding(.horizontal)

                            if myEvents.isEmpty {
                                EmptyStateView(
                                    icon: "calendar.badge.plus",
                                    title: "No events yet",
                                    subtitle: "Create your first wellness event and start building your community."
                                )
                                .padding(.horizontal)
                            } else {
                                ForEach(myEvents) { event in
                                    OrganizerEventRow(
                                        event: event,
                                        onEdit: { eventToEdit = event },
                                        onViewAttendees: { attendeeEvent = event },
                                        onDelete: {
                                            eventToDelete = event
                                            showDeleteAlert = true
                                        }
                                    )
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.bottom, 24)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCreateEvent = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color.appBlue)
                            .font(.title3)
                    }
                }
            }
            .navigationDestination(item: $attendeeEvent) { event in
                AttendeeListView(event: event)
            }
            .sheet(isPresented: $showCreateEvent) {
                CreateEventView()
            }
            .sheet(item: $eventToEdit) { event in
                EditEventView(event: event)
            }
            .alert("Delete Event?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let id = eventToDelete?.id {
                        eventsViewModel.deleteEvent(id: id)
                    }
                    eventToDelete = nil
                }
                Button("Cancel", role: .cancel) { eventToDelete = nil }
            } message: {
                Text("This action cannot be undone. The event and all its data will be permanently removed.")
            }
        }
    }
}

private struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.appDarkText)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.05), radius: 6)
    }
}

private struct OrganizerEventRow: View {
    let event: WellnessEvent
    let onEdit: () -> Void
    let onViewAttendees: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(event.category.badgeColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: event.imageName)
                        .font(.title3)
                        .foregroundStyle(event.category.badgeColor)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.appDarkText)
                        .lineLimit(1)
                    HStack(spacing: 6) {
                        CategoryBadge(category: event.category, small: true)
                        Text(event.date.formatted(.dateTime.month().day().year()))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Menu {
                    Button("Edit Event", systemImage: "pencil") {
                        onEdit()
                    }
                    Button("View Attendees", systemImage: "person.2") {
                        onViewAttendees()
                    }
                    Divider()
                    Button("Delete Event", systemImage: "trash", role: .destructive) {
                        onDelete()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                        .foregroundStyle(Color.appBlue)
                }
            }

            Divider().padding(.vertical, 10)

            // Stats row
            HStack(spacing: 0) {
                MiniStat(icon: "person.2.fill", value: "\(event.attendeeCount)/\(event.maxCapacity)", label: "Attendees", color: Color.appMint)
                Divider().frame(height: 30)
                MiniStat(icon: "dollarsign", value: String(format: "$%.0f", event.revenue), label: "Revenue", color: Color.appBlue)
                Divider().frame(height: 30)
                MiniStat(
                    icon: "chart.bar.fill",
                    value: "\(Int(Double(event.attendeeCount) / Double(max(event.maxCapacity, 1)) * 100))%",
                    label: "Capacity",
                    color: Color.appLavender
                )
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.05), radius: 6)
    }
}

private struct MiniStat: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: icon).font(.caption).foregroundStyle(color)
            Text(value).font(.subheadline).fontWeight(.bold).foregroundStyle(Color.appDarkText)
            Text(label).font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    DashboardView()
        .environment(AuthViewModel())
        .environment(EventsViewModel())
}
