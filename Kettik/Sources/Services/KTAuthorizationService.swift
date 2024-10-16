//
//  KTAuthorizationService.swift
//  Kettik
//
//  Created by Tami on 01.05.2024.
//

import FirebaseAuth
import GoogleSignIn
import RxCocoa
import RxSwift

final class KTAuthorizationService: KTFirebaseServiceType {
    
    var collection: String {
        "users"
    }
    
    var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    private(set) var currentUserProfile: KTUser?
    
    private let controller: KTSignInScreen? = nil
    
    private let disposeBag: DisposeBag = .init()
    
    var isAuthorized: Bool {
        Auth.auth().currentUser != nil
    }
}

extension KTAuthorizationService: KTSplashLoadable {
    
    func loadInitialData(_ completion: @escaping () -> Void) {
        if isAuthorized, let userId = userId {
            rxGetProfile(userId: userId)
                .subscribe(onSuccess: { _ in
                    completion()
                }, onFailure: { _ in
                    completion()
                })
                .disposed(by: disposeBag)
        } else {
            completion()
        }
    }
}

extension KTAuthorizationService {
    
    func rxSignOut() -> Single<Void> {
        Single<Void>.create { single in
            do {
                try Auth.auth().signOut()
                single(.success(()))
            } catch let error {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    func rxSignIn(email: String, password: String) -> Single<String> {
        Single<String>.create { single in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    single(.failure(error))
                } else if let id = Auth.auth().currentUser?.uid {
                    single(.success(id))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func rxConfigureGoogleSignIn(from controller: UIViewController) -> Single<String> {
        Single<String>.create { single in
            GIDSignIn.sharedInstance.signIn(withPresenting: controller) {result, error in
                if let error = error {
                    single(.failure(error))
                }
                guard let user = result?.user, let idToken = user.idToken else {
                    single(.failure(NSError(domain: "GoogleSignInError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get user or idToken"])))
                    return
                }
                let credentials = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString)
                
                Auth.auth().signIn(with: credentials) { authResult, signInError in
                    if let signInError = signInError {
                        single(.failure(signInError))
                    } else if let id = authResult?.user.uid {
                        single(.success(id))
                    } else {
                        single(.failure(NSError(domain: "FirebaseAuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get user ID"])))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func rxSignUp(email: String, password: String) -> Single<String> {
        Single<String>.create { single in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    single(.failure(error))
                } else if let userId = result?.user.uid {
                    single(.success(userId))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func rxGetProfile(userId: String) -> Single<KTUser> {
        let observableUser: Single<KTUser> = rxMapDocument(id: userId)
        return observableUser
            .map { [weak self] user in
                self?.currentUserProfile = user
                return user
            }
    }
    
    func rxCreateProfile(id: String, data: [String: Any]) -> Single<KTUser> {
        rxCreateDocument(id: id, data: data)
            .flatMap { [weak self] in
                guard let self = self else {
                    return Single.error(KTError.unknown)
                }
                return self.rxGetProfile(userId: id)
            }
    }
}
