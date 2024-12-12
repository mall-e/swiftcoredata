import SwiftUI
import CoreData

struct AdminOgrencilerView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Kullanici.kullaniciAdi, ascending: true)],
        predicate: NSPredicate(format: "isAdmin == NO"),
        animation: .default)
    private var ogrenciler: FetchedResults<Kullanici>

    var body: some View {
        NavigationView {
            List {
                ForEach(ogrenciler) { ogrenci in
                    NavigationLink(destination: AdminOgrenciKitaplarView(ogrenci: ogrenci)) {
                        Text(ogrenci.kullaniciAdi ?? "Bilinmiyor")
                    }
                }
            }
            .navigationTitle("Öğrenciler")
        }
    }
}
