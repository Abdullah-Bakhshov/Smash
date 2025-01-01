//
//  ClientforAPI.swift
//  Smash
//
//  Created by Abdullah B on 24/11/2024.
//

import Foundation


struct ClientForAPI {
    
    init() {}
    
    func sendvideo(path: URL, route: String, httpmethod: String) async {
        
        // setting the key for the what the boundary will be
        let boundary = "Boundary-\(UUID().uuidString)"
        
        // where we are making the request to, the URI
        var request = URLRequest(url: URL(string: "\(route)")!)
        
        
        // type of request we are making , as we are uploading a video file we are making a post request
        request.httpMethod = httpmethod
        
        // sending multipart/form-data across and specifiing what the boundary is so it knows when the
        // file is completed
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // defining the body of the request as data type
        var body = Data()
        
        // setting the boundary as a data type
        let boundaryData = "--\(boundary)\r\n".data(using: .utf8)!
        
        // setting the header of each part as form-data, and we are saying its type is file and telling the name of the file, \r\n standard for multipart
        let contentDispositionData = "Content-Disposition: form-data; name=\"file\"; filename=\"\(path.lastPathComponent)\"\r\n".data(using: .utf8)!
        
        // setting the content type as video/quicktime
        let contentTypeData = "Content-Type: video/quicktime\r\n\r\n".data(using: .utf8)!
        
        // setting this as the end of the boundary
        let closingBoundaryData = "\r\n--\(boundary)--\r\n".data(using: .utf8)!
        
        do {
            
            // Boundary-6E0C8D7F-92DE-4CC5-B4EE-4FE5F83467E6
            body.append(boundaryData)
            
            // Content-Disposition: form-data; name="file\"; filename=example.mov
            body.append(contentDispositionData)
            
            // Content-Type: video/quicktime
            body.append(contentTypeData)
            
            // the video file content
            let fileData = try Data(contentsOf: path)
            body.append(fileData)
            
            // --Boundary-6E0C8D7F-92DE-4CC5-B4EE-4FE5F83467E6--
            body.append(closingBoundaryData)
            
        } catch {
            print("Error reading file: \(error.localizedDescription)")
            return
        }
        
        request.httpBody = body
        
        // sending the data
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            print("Response: \(response)")
        } catch {
            print("Error sending request: \(error.localizedDescription)")
        }
    }
    
    func getAccount(username: String) async -> [String] {
        
        // We chaneg this when we make ec2 instance
        var request = URLRequest(url: URL(string: "https://97f5-2a00-23c5-a94-7301-932-45e4-dfa7-8c31.ngrok-free.app/user_meta_retrieving")!)
        request.httpMethod = "PUT"
        request.httpBody = username.data(using: .utf8)
        
        do {
            let (value, _) = try await URLSession.shared.data(for: request)
            let output = String(decoding: value, as: UTF8.self)
            if output == "" {
                return ["",""]
            }
            let outputArray = output.components(separatedBy: ",")
            print("This is the username: \(outputArray[0]), This is the password: \(outputArray[1])")
            return outputArray
            
        } catch {
            print("Error seding request: \(error.localizedDescription)")
            return [""]
        }
        
    }
    
    func makeAccount(username: String, password: String) async {
        
        var request = URLRequest(url: URL(string: "https://97f5-2a00-23c5-a94-7301-932-45e4-dfa7-8c31.ngrok-free.app/user_meta_storing")!)
        request.httpMethod = "POST"
        request.httpBody = "\(username),\(password)".data(using: .utf8)
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            print("Response: \(response)")
            
        } catch {
            print("Error sending request: \(error.localizedDescription)")
            
        }
    }
}
