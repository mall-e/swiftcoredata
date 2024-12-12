import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var oturumAcik: Bool = true // Çıkış yapmak için kontrol
    @State private var kitapEkleModalAcik: Bool = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Kitap.baslik, ascending: true)],
        animation: .default)
    private var kitaplar: FetchedResults<Kitap>

    var body: some View {
        if oturumAcik {
            NavigationView {
                List {
                    ForEach(kitaplar) { kitap in
                        NavigationLink(destination: KitapDuzenleView(kitap: kitap)) {
                            Text(kitap.baslik ?? "Bilinmiyor")
                        }
                    }
                    .onDelete(perform: deleteKitap)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            oturumAcik = false // Çıkış işlemi
                        }) {
                            Text("Çıkış Yap")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: {
                            kitapEkleModalAcik = true
                        }) {
                            Label("Kitap Ekle", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $kitapEkleModalAcik) {
                    KitapEkleView(isPresented: $kitapEkleModalAcik)
                }
                .navigationTitle("Kitaplar")
            }
        } else {
            LoginView()
        }
    }

    private func deleteKitap(offsets: IndexSet) {
        withAnimation {
            offsets.map { kitaplar[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Kitap silinirken hata oluştu: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}




private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
