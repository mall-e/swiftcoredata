//
//  KitapDuzenleView.swift
//  mobil
//
//  Created by Muhammet Ali Yazıcı on 12.12.2024.
//

import SwiftUI
import CoreData

struct KitapDuzenleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var kitap: Kitap
    @Environment(\.presentationMode) var presentationMode

    @State private var yeniBaslik: String = ""
    @State private var yeniYazar: String = ""
    @State private var yeniTur: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Kitap Düzenle")
                .font(.largeTitle)
                .bold()

            TextField("Başlık", text: $yeniBaslik)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)

            TextField("Yazar", text: $yeniYazar)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)

            TextField("Tür", text: $yeniTur)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)

            Button(action: kaydet) {
                Text("Kaydet")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("İptal")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            yeniBaslik = kitap.baslik ?? ""
            yeniYazar = kitap.yazar ?? ""
            yeniTur = kitap.tur ?? ""
        }
    }

    private func kaydet() {
        kitap.baslik = yeniBaslik
        kitap.yazar = yeniYazar
        kitap.tur = yeniTur

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Kitap düzenlenirken hata oluştu: \(error.localizedDescription)")
        }
    }
}
