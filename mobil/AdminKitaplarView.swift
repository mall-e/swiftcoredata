//
//  AdminKitaplarView.swift
//  mobil
//
//  Created by Muhammet Ali Yazıcı on 12.12.2024.
//

import SwiftUI
import CoreData

struct AdminKitaplarView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var kitapEkleModalAcik: Bool = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Kitap.baslik, ascending: true)],
        animation: .default)
    private var kitaplar: FetchedResults<Kitap>

    var body: some View {
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
