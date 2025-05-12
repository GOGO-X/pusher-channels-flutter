import Foundation
import PusherSwift

public class DefaultAuthRequestBuilder: AuthRequestBuilderProtocol {

    private let authUrlString: String
    private let headers: [String: String]

    public init(authUrlString: String, headers: [String: String] = [:]) {
        self.authUrlString = authUrlString
        self.headers = headers
    }

    public func requestFor(socketID: String, channelName: String) -> URLRequest? {
        let allowedCharacterSet = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted
        let encodedChannelName = channelName.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? channelName

        var request = URLRequest(url: URL(string: authUrlString)!)
        request.httpMethod = "POST"
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpBody = "socket_id=\(socketID)&channel_name=\(encodedChannelName)".data(using: String.Encoding.utf8)

        return request
    }
}
