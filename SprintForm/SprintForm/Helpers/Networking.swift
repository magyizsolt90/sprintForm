//
//  Networking.swift
//  SprintForm
//
//  Created by Zsolt Magyi on 2024.02.15.
//

import Foundation


class Networking {
    private init() {}
    static let shared = Networking()
}

//MARK: - Networking callables
extension Networking {
    func downloadTransactions(completion: @escaping ((_ transactions: [TransactionVM]?, _ error: TransactionError?) -> Void)) {
        guard let request = createRequest(url: URLs.getTransactions) else { return }
        
        createSession(request) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let transactions = try decoder.decode([Transaction].self, from: response)
                    let transactionVMs = transactions.map({ TransactionVM(with: $0) })
                    completion(transactionVMs, nil)
                } catch {
                    completion(nil, .invalidJsonFomatError)
                }
            case .failure(let error):
                print("ERROR: " + error.localizedDescription)
                completion(nil, error)
            }
        }
    }
}

//MARK: - Networking helpers
extension Networking {
    private func createRequest(url: String, httpMethod: HttpMethod = .GET) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.timeoutInterval = .infinity
        addHeadersToRequest(&request, headers: [:])
        return request
    }
    
    private func createSession(_ request: URLRequest, completion: @escaping ((Result<Data, TransactionError>) -> Void)) {
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if data == nil {
                completion(.failure(.noResponseError))
            } else {
                if let statusCode = self.getStatusCode(response: response) {
                    if (200..<300) ~= statusCode {
                        completion(.success(data!))
                    } else {
                        completion(.failure(.invalidSessionError))
                    }
                } else {
                    completion(.failure(.invalidSessionError))
                }
            }


        })
        if task.state == .running {
            task.cancel()
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }

    private func addBodyToRequest(request: inout URLRequest, data: Data?) {
        request.httpBody = data
    }
    
    private func getStatusCode(response: URLResponse?) -> Int? {
        if let httpResponse = response as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
    
    private func addHeadersToRequest(_ request: inout URLRequest, headers: Dictionary<String, String>) {
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
}
