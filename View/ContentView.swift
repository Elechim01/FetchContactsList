//
//  ContentView.swift
//  FetchContactsList
//
//  Created by Michele Manniello on 30/07/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var contactsVM = ContactsViewModel()
    
    var body: some View {
        VStack {
            HStack{
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search",text: $contactsVM.searchText) { isEditing in
                        self.contactsVM.showCancelButton = true
                    }
                    
                    Button {
                        self.contactsVM.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .opacity(self.contactsVM.searchText == "" ? 0 : 1)
                    }
                }
                .padding(8)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                if self.contactsVM.showCancelButton{
                    Button("Cancel") {
                               UIApplication.shared.endEditing(true)
                        self.contactsVM.searchText = ""
                        self.contactsVM.showCancelButton = false
                         }
                
                }
            }
            .padding([.leading,.trailing,.top])
            List{
                ForEach(self.contactsVM.contacts.filter({ (cont) -> Bool in
                    self.contactsVM.searchText.isEmpty ? true :
                    "\(cont)".lowercased().contains(self.contactsVM.searchText.lowercased())
                })){contact in
                    ContactRow(contact: contact)
                }
            }
           
        }
        .onAppear{
            self.contactsVM.requestAccess()
        }
    }
    
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContactRow: View {
    var contact: ContactInfo
    var body: some View{
        Text("\(contact.firstName) \(contact.lastName)")
            .foregroundColor(.primary)
    }
}
