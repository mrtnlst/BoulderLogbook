import SwiftUI

/// Solely used to show highlighting when rows are tapped in custom SwiftUI List.
struct PlainRowButton<Label: View>: View {
    struct Style: ButtonStyle {
        var onPress: (Bool) -> Void

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                // Extends tappable area in list to edges.
                .contentShape(Rectangle())
                .onChange(of: configuration.isPressed) { _, isPressed in
                    onPress(isPressed)
                }
        }
    }

    let action: () -> Void
    @ViewBuilder let label: () -> Label
    @State var isPressed: Bool = false
    
    var body: some View {
        Button(action: action) {
            label()
        }
        .listRowBackground(isPressed ? Color.araMidGray : .araRowBackground)
        .buttonStyle(Style { self.isPressed = $0 })
    }
}

#Preview {
    PlainList {
        PlainSection {
            PlainRowButton(action: {}) {
                DashboardEntryView(
                    entry: Logbook.Section.samples.first!.entries.first!,
                    gradeSystem: .mandala
                )
            }
        }
    }
}
