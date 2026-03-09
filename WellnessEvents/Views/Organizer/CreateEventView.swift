import SwiftUI

struct CreateEventView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(EventsViewModel.self) private var eventsViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var description = ""
    @State private var category: EventCategory = .yoga
    @State private var date = Date().addingTimeInterval(86400 * 7)
    @State private var location = ""
    @State private var maxCapacity = 20
    @State private var ticketPrice = 75.0
    @State private var selectedImageName = "figure.yoga"
    @State private var showImagePicker = false

    @State private var scheduleItems: [ScheduleItem] = [
        ScheduleItem(time: "9:00 AM", activity: "")
    ]

    let sfSymbolOptions = [
        "figure.yoga", "brain.head.profile", "waveform", "leaf.fill",
        "person.2.fill", "wind", "heart.fill", "star.fill",
        "figure.mind.and.body", "sparkles", "sun.max.fill", "moon.fill"
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBeige.ignoresSafeArea()

                Form {
                    // Basic Info
                    Section {
                        FormTextField(label: "Event Title", placeholder: "e.g. Sunrise Yoga in Bali", text: $title)
                        FormTextEditor(label: "Description", text: $description)
                    } header: {
                        SectionLabel(text: "Basic Information")
                    }
                    .listRowBackground(Color.white)

                    // Category & Image
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.appBlue)
                            Picker("Category", selection: $category) {
                                ForEach(EventCategory.allCases) { cat in
                                    Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(Color.appBlue)
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Cover Icon")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.appBlue)
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                                ForEach(sfSymbolOptions, id: \.self) { symbol in
                                    Button {
                                        selectedImageName = symbol
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(selectedImageName == symbol ? Color.appMint : Color.appGray.opacity(0.2))
                                                .frame(height: 44)
                                            Image(systemName: symbol)
                                                .font(.title3)
                                                .foregroundStyle(selectedImageName == symbol ? Color(hex: "1E5631") : .secondary)
                                        }
                                    }
                                }
                            }
                        }
                    } header: {
                        SectionLabel(text: "Event Style")
                    }
                    .listRowBackground(Color.white)

                    // Date & Location
                    Section {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Date & Time")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.appBlue)
                            DatePicker("", selection: $date, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                                .tint(Color.appBlue)
                        }
                        FormTextField(label: "Location", placeholder: "City, Country", text: $location)
                    } header: {
                        SectionLabel(text: "When & Where")
                    }
                    .listRowBackground(Color.white)

                    // Capacity & Price
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Max Capacity")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.appBlue)
                            HStack {
                                Slider(value: Binding(
                                    get: { Double(maxCapacity) },
                                    set: { maxCapacity = Int($0) }
                                ), in: 5...200, step: 5)
                                .tint(Color.appMint)
                                Text("\(maxCapacity) people")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.appDarkText)
                                    .frame(width: 90)
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Ticket Price")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.appBlue)
                                Spacer()
                                Text(ticketPrice == 0 ? "Free" : String(format: "$%.0f", ticketPrice))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.appMint)
                            }
                            Slider(value: $ticketPrice, in: 0...2000, step: 5)
                                .tint(Color.appMint)
                            HStack {
                                Text("Free").font(.caption).foregroundStyle(.secondary)
                                Spacer()
                                Text("$2000").font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    } header: {
                        SectionLabel(text: "Capacity & Pricing")
                    }
                    .listRowBackground(Color.white)

                    // Schedule
                    Section {
                        ForEach($scheduleItems) { $item in
                            HStack(spacing: 10) {
                                TextField("Time", text: $item.time)
                                    .frame(width: 80)
                                    .padding(8)
                                    .background(Color.appLavender.opacity(0.15))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                TextField("Activity", text: $item.activity)
                                    .padding(8)
                                    .background(Color.appLavender.opacity(0.15))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .onDelete { scheduleItems.remove(atOffsets: $0) }

                        Button {
                            scheduleItems.append(ScheduleItem(time: "", activity: ""))
                        } label: {
                            Label("Add Schedule Item", systemImage: "plus.circle")
                                .foregroundStyle(Color.appBlue)
                        }
                    } header: {
                        SectionLabel(text: "Schedule (Optional)")
                    }
                    .listRowBackground(Color.white)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Create Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.appBlue)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Publish") {
                        saveEvent()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(title.isEmpty || location.isEmpty ? Color.secondary : Color.appMint)
                    .disabled(title.isEmpty || location.isEmpty)
                }
            }
        }
    }

    private func saveEvent() {
        guard let user = authViewModel.currentUser else { return }
        let cleanedSchedule = scheduleItems.filter { !$0.activity.isEmpty }
        let event = WellnessEvent(
            title: title,
            description: description,
            category: category,
            date: date,
            location: location,
            maxCapacity: maxCapacity,
            ticketPrice: ticketPrice,
            organizerId: user.id,
            organizerName: user.name,
            organizerBio: user.bio,
            imageName: selectedImageName,
            schedule: cleanedSchedule
        )
        eventsViewModel.addEvent(event)
        dismiss()
    }
}

struct SectionLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(Color.appBlue)
            .textCase(nil)
    }
}

struct FormTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color.appBlue)
            TextField(placeholder, text: $text)
        }
    }
}

struct FormTextEditor: View {
    let label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color.appBlue)
            TextEditor(text: $text)
                .frame(minHeight: 100)
                .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    CreateEventView()
        .environment(AuthViewModel())
        .environment(EventsViewModel())
}
