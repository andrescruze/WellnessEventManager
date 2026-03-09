import SwiftUI

struct SearchView: View {
    @Environment(EventsViewModel.self) private var eventsViewModel
    @FocusState private var searchFocused: Bool

    var body: some View {
        @Bindable var vm = eventsViewModel

        NavigationStack {
            ZStack {
                Color.appBeige.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Search bar
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(searchFocused ? Color.appBlue : Color.secondary)
                        TextField("Search events, locations, organizers...", text: $vm.searchText)
                            .focused($searchFocused)
                            .autocorrectionDisabled()
                        if !vm.searchText.isEmpty {
                            Button {
                                vm.searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                    .padding(12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(searchFocused ? Color.appBlue : Color.appGray, lineWidth: 1.5)
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 12)

                    // Filters
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(alignment: .leading, spacing: 20) {
                            // Category filter
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Category")
                                    .font(.headline)
                                    .foregroundStyle(Color.appBlue)
                                    .padding(.horizontal)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        FilterChip(
                                            label: "All",
                                            isSelected: vm.selectedCategory == nil
                                        ) {
                                            withAnimation { vm.selectedCategory = nil }
                                        }
                                        ForEach(EventCategory.allCases) { cat in
                                            FilterChip(
                                                label: cat.rawValue,
                                                icon: cat.icon,
                                                isSelected: vm.selectedCategory == cat
                                            ) {
                                                withAnimation {
                                                    vm.selectedCategory = vm.selectedCategory == cat ? nil : cat
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }

                            // Price filter
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Max Price")
                                        .font(.headline)
                                        .foregroundStyle(Color.appBlue)
                                    Spacer()
                                    Text(vm.maxPrice >= 2000 ? "Any price" : String(format: "Up to $%.0f", vm.maxPrice))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.appMint)
                                }
                                .padding(.horizontal)

                                Slider(value: $vm.maxPrice, in: 0...2000, step: 25)
                                    .tint(Color.appMint)
                                    .padding(.horizontal)

                                HStack {
                                    Text("Free")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    Text("$2000+")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.horizontal)
                            }

                            // Results
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Results")
                                        .font(.headline)
                                        .foregroundStyle(Color.appDarkText)
                                    Spacer()
                                    Text("\(eventsViewModel.filteredEvents.count) events")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.horizontal)

                                if eventsViewModel.filteredEvents.isEmpty {
                                    EmptyStateView(
                                        icon: "magnifyingglass",
                                        title: "No events match your search",
                                        subtitle: "Try adjusting your filters or explore a different category. New events are added regularly!"
                                    )
                                    .padding(.horizontal)
                                } else {
                                    ForEach(eventsViewModel.filteredEvents) { event in
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
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct FilterChip: View {
    let label: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let icon {
                    Image(systemName: icon).font(.caption)
                }
                Text(label).font(.caption).fontWeight(.medium)
            }
            .foregroundStyle(isSelected ? Color(hex: "1E5631") : .secondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color.appMint : Color.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.05), radius: 4)
        }
    }
}

#Preview {
    SearchView()
        .environment(EventsViewModel())
}
