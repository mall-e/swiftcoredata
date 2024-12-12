//
//  KitapEkleView.swift
//  mobil
//
//  Created by Muhammet Ali Yazıcı on 12.12.2024.
//
import SwiftUI
import CoreData

struct KitapEkleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isPresented: Bool

    @State private var baslik: String = ""
    @State private var yazar: String = ""
    @State private var tur: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Kitap Bilgileri")) {
                    TextField("Başlık", text: $baslik)
                    TextField("Yazar", text: $yazar)
                    TextField("Tür", text: $tur)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        kitapEkle()
                    }
                }
            }
            .navigationTitle("Yeni Kitap Ekle")
        }
    }

    private func kitapEkle() {
        let yeniKitap = Kitap(context: viewContext)
        yeniKitap.id = UUID()
        yeniKitap.baslik = baslik
        yeniKitap.yazar = yazar
        yeniKitap.tur = tur
        yeniKitap.okunduMu = false

        do {
            try viewContext.save()
            isPresented = false
        } catch {
            print("Kitap eklenirken hata oluştu: \(error.localizedDescription)")
        }
    }
}

