import SwiftUI
import CoreData

struct OgrenciContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var oturumAcik: Bool = true // Çıkış yapmak için kontrol

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Kitap.baslik, ascending: true)],
        animation: .default)
    private var kitaplar: FetchedResults<Kitap>

    var body: some View {
        if oturumAcik {
            NavigationView {
                List {
                    ForEach(kitaplar) { kitap in
                        NavigationLink(destination: KitapDetayView(kitap: kitap)) {
                            Text(kitap.baslik ?? "Bilinmiyor")
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            oturumAcik = false // Çıkış işlemi
                        }) {
                            Text("Çıkış Yap")
                        }
                    }
                }
                .navigationTitle("Kitaplar")
            }
        } else {
            LoginView()
        }
    }
}

struct KitapDetayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var kitap: Kitap

    var body: some View {
        VStack(spacing: 20) {
            Text("Kitap Detayları")
                .font(.largeTitle)
                .bold()

            Text("Başlık: \(kitap.baslik ?? "Bilinmiyor")")
            Text("Yazar: \(kitap.yazar ?? "Bilinmiyor")")
            Text("Tür: \(kitap.tur ?? "Bilinmiyor")")

            Button(action: {
                kitap.okunduMu.toggle()
                do {
                    try viewContext.save()
                } catch {
                    print("Okundu durumu güncellenirken hata oluştu: \(error.localizedDescription)")
                }
            }) {
                Text(kitap.okunduMu ? "Okundu" : "Okunmadı")
                    .foregroundColor(kitap.okunduMu ? .green : .red)
            }
        }
        .padding()
    }
}
