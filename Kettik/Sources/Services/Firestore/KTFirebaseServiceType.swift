//
//  KTFirestoreService.swift
//  Kettik
//
//  Created by Tami on 01.05.2024.
//

import RxSwift
import FirebaseFirestore

protocol KTFirebaseServiceType {
    
    var collection: String { get }
    
    func getCollectionReference() -> FirebaseFirestore.CollectionReference
    
    func getDocumentReference(id: String) -> FirebaseFirestore.DocumentReference
    
    func rxGetDocuments() -> Single<[QueryDocumentSnapshot]>
    
    func rxGetDocuments(query: FirebaseFirestore.Query) -> Single<[QueryDocumentSnapshot]>
    
    func rxGetDocument(id: String) -> Single<DocumentSnapshot>
    
    func rxMapDocument<T: FBSnapshotInitializable>(id: String) -> Single<T>
    
    func rxCreateDocument(id: String, data: [String: Any]) -> Single<Void>
}

extension KTFirebaseServiceType {
    
    func getCollectionReference() -> FirebaseFirestore.CollectionReference {
        return Firestore.firestore().collection(collection)
    }
    
    func getDocumentReference(id: String) -> FirebaseFirestore.DocumentReference {
        getCollectionReference().document(id)
    }
    
    func rxGetDocuments() -> Single<[QueryDocumentSnapshot]> {
        let reference: CollectionReference = getCollectionReference()
        return Single<[QueryDocumentSnapshot]>.create { single in
            reference
                .getDocuments { snapshot, error in
                    if let documents = snapshot?.documents {
                        single(.success(documents))
                    } else if let error = error {
                        single(.failure(error))
                    } else {
                        single(.failure(KTError.unknown))
                    }
                }
            return Disposables.create()
        }
    }
    
    func rxGetDocuments(query: FirebaseFirestore.Query) -> Single<[QueryDocumentSnapshot]> {
        return Single<[QueryDocumentSnapshot]>.create { single in
            query
                .getDocuments { snapshot, error in
                    if let documents = snapshot?.documents {
                        single(.success(documents))
                    } else if let error = error {
                        single(.failure(error))
                    } else {
                        single(.failure(KTError.unknown))
                    }
                }
            return Disposables.create()
        }
    }
    
    func rxGetDocument(id: String) -> Single<DocumentSnapshot> {
        let reference: FirebaseFirestore.DocumentReference = getDocumentReference(id: id)
        return Single<DocumentSnapshot>.create { single in
            reference
                .getDocument { snapshot, error in
                    if let snapshot = snapshot {
                        single(.success(snapshot))
                    } else if let error = error {
                        single(.failure(error))
                    } else {
                        single(.failure(KTError.unknown))
                    }
                }
            return Disposables.create()
        }
    }
    
    func rxMapDocument<T: FBSnapshotInitializable>(id: String) -> Single<T> {
        let reference: FirebaseFirestore.DocumentReference = getDocumentReference(id: id)
        return Single<T>.create { single in
            reference
                .getDocument { snapshot, error in
                    if let snapshot = snapshot {
                        if let mapped: T = .init(documentSnapshot: snapshot) {
                            single(.success(mapped))
                        } else {
                            single(.failure(KTError.parsingError))
                        }
                    } else if let error = error {
                        single(.failure(error))
                    } else {
                        single(.failure(KTError.unknown))
                    }
                }
            return Disposables.create()
        }
    }
    
    func rxCreateDocument(id: String, data: [String: Any]) -> Single<Void> {
        let reference: FirebaseFirestore.CollectionReference = getCollectionReference()
        return Single<Void>.create { single in
            reference.document(id).setData(data, merge: true, completion: { error in
                if let error = error {
                    single(.failure(error))
                } else {
                    single(.success(()))
                }
            })
            return Disposables.create()
        }
    }
}
