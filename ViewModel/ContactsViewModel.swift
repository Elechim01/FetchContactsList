//
//  ContactsViewModel.swift
//  FetchContactsList
//
//  Created by Michele Manniello on 30/07/22.
//

import UIKit
import Contacts

class ContactsViewModel: ObservableObject{
    
    @Published var contacts : [ContactInfo] = []
    @Published var searchText = ""
    @Published var showCancelButton: Bool = false
    
    func fetchingContacts() -> [ContactInfo] {
        var contacts = [ContactInfo]()
        let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        do {
            try CNContactStore().enumerateContacts(with: request, usingBlock: { contact, stopPointer in
                contacts.append(ContactInfo(firstName: contact.givenName, lastName: contact.familyName,phoneNumber: contact.phoneNumbers.first?.value))
            })
        } catch let error  {
            print("Fallied",error)
        }
      contacts = contacts.sorted{$0.firstName < $1.firstName}
        return contacts
    }
    
    func getContacts(){
        DispatchQueue.main.async {
            self.contacts = self.fetchingContacts()
        }
       
    }
    
    func requestAccess(){
        let store = CNContactStore()
        switch CNContactStore.authorizationStatus(for: .contacts){
        case .authorized:
            self.getContacts()
        case .notDetermined, .restricted,.denied:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    self.getContacts()
                }
            }
    
        @unknown default:
            print("Error")
        }
    }
    
}
extension UIApplication{
    func endEditing(_ force: Bool){
        self.windows.filter{$0.isKeyWindow}.first?.endEditing(force)
    }
}
