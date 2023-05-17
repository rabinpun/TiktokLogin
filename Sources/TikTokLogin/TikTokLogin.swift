
import UIKit
import TikTokOpenSDK
import Combine

@available(iOS 13.0, *)
public class TikTokLogin {
    
    public let tiktokResponse = PassthroughSubject<Result<String,Error>,Never>()
    let scopes: [String]
    
    public init(scopes: [String] = ["user.info.basic"]) {
        self.scopes = scopes
    }
    
    public func performLogin(with controller: UIViewController) {
        let scopesSet = NSOrderedSet(array:scopes)
        let request = TikTokOpenSDKAuthRequest()
        request.permissions = scopesSet

        request.send(controller, completion: { [weak self] resp -> Void in
            guard let self = self else { return }
            guard resp.isSucceed else {
                self.tiktokResponse.send(.failure(NSError.init(domain: "authentication cancelled", code: 0)))
                return }
            guard let code = resp.code else {
                self.tiktokResponse.send(.failure(NSError.init(domain: resp.errString ?? "unknown error", code: 0)))
                return
            }
            self.tiktokResponse.send(.success(code))
            })
    }
}
