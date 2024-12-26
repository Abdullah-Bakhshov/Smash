//
//  S3Requests.swift
//  Smash
//
//  Created by Abdullah B on 21/12/2024.
//


import AWSS3
import Foundation

struct S3Requests {
    init() {
        AWSConfig.setup()
    }

    // Function to upload file to S3
    func uploadFile(to bucket: String, key: String, fileURL: URL) async {
        let transferUtility = AWSS3TransferUtility.default()

        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = { task, progress in
            print("Upload progress: \(progress.fractionCompleted)")
        }

        do {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                transferUtility.uploadFile(
                    fileURL,
                    bucket: bucket,
                    key: key,
                    contentType: "video/mp4",
                    expression: expression
                ) { task, error in
                    if let error = error as NSError? {
                        print("Upload failed: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    } else {
                        print("Upload succeeded")
                        continuation.resume()
                    }
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    // Generate pre-signed URL for a given object in S3
    func generatePreSignedURL(bucket: String, key: String, expirationTime: TimeInterval = 3600) async -> URL? {
        let request = AWSS3GetPreSignedURLRequest()
        request.bucket = bucket
        request.key = key
        request.httpMethod = .GET
        request.expires = Date().addingTimeInterval(expirationTime)

        let builder = AWSS3PreSignedURLBuilder.default()

        do {
            let preSignedURL: URL = try await withCheckedThrowingContinuation { continuation in
                builder.getPreSignedURL(request).continueWith { task in
                    if let error = task.error {
                        continuation.resume(throwing: error)
                    } else if let result = task.result {
                        continuation.resume(returning: result as URL)
                    } else {
                        continuation.resume(throwing: NSError(domain: "UnknownError", code: -1, userInfo: nil))
                    }
                    return nil
                }
            }
            return preSignedURL
        } catch {
            print("Error generating pre-signed URL: \(error.localizedDescription)")
            return nil
        }
    }

    // List files in the S3 bucket
    func listFiles(from bucket: String) async -> [String] {
        var fileKeys: [String] = []

        guard let configuration = AWSConfig.getServiceConfiguration() else {
            print("Error: AWSServiceConfiguration is not set up.")
            return fileKeys
        }

        AWSServiceManager.default().defaultServiceConfiguration = configuration
        let s3 = AWSS3.default()

        let listRequest = AWSS3ListObjectsRequest()
        listRequest?.bucket = bucket

        do {
            let task = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[String], Error>) in
                s3.listObjects(listRequest!).continueWith { task in
                    if let error = task.error {
                        print("Error during S3 request: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    } else if let result = task.result, let objects = result.contents {
                        fileKeys = objects.compactMap { $0.key }
                        continuation.resume(returning: fileKeys)
                    } else {
                        continuation.resume(returning: [])
                    }
                    return nil
                }
            }
            return task
        } catch {
            print("Error listing files: \(error.localizedDescription)")
            return []
        }
    }

    // Function to delete a file from S3
    func deleteFile(from bucket: String, key: String) async -> Bool {
        let s3 = AWSS3.default()
        let deleteRequest = AWSS3DeleteObjectRequest()
        deleteRequest?.bucket = bucket
        deleteRequest?.key = key

        do {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                s3.deleteObject(deleteRequest!).continueWith { task in
                    if let error = task.error {
                        print("Error deleting file: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    } else {
                        print("File deleted successfully")
                        continuation.resume()
                    }
                    return nil
                }
            }
            return true
        } catch {
            print("Error deleting file from S3: \(error.localizedDescription)")
            return false
        }
    }

}

