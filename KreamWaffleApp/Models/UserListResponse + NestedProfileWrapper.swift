//
//  UserListResponse.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2023/01/31.
//

import Foundation

class UserListResponse {
    let next: String?
    let previous: String?
    let results: [NestedProfile]
    
    init(
        next: String?,
        previous: String?,
        results: [NestedProfile]
    ) {
        self.next = next
        self.previous = previous
        self.results = results
    }
}

class UserListResponseWithFromAtPrefix : Decodable {
    private enum CodingKeys: String, CodingKey {
        case next, previous, results
    }
    
    let next: String?
    let previous: String?
    let results: [NestedProfileWrapperWithFromAtPrefix]
    
    init(
        next: String?,
        previous: String?,
        results: [NestedProfileWrapperWithFromAtPrefix]
    ) {
        self.next = next
        self.previous = previous
        self.results = results
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        next = try container.decodeIfPresent(String.self, forKey: .next) ?? nil
        previous = try container.decodeIfPresent(String.self, forKey: .previous) ?? nil
        results = try container.decodeIfPresent([NestedProfileWrapperWithFromAtPrefix].self, forKey: .results) ?? []
    }
}

class NestedProfileWrapperWithFromAtPrefix : Decodable {
    private enum CodingKeys: String, CodingKey {
        case from_profile
    }
    
    let nestedProfile: NestedProfile
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        nestedProfile = try container.decodeIfPresent(NestedProfile.self, forKey: .from_profile) ?? NestedProfile()
    }
}

class UserListResponseWithToAtPrefix : Decodable {
    private enum CodingKeys: String, CodingKey {
        case next, previous, results
    }
    
    let next: String?
    let previous: String?
    let results: [NestedProfileWrapperWithToAtPrefix]
    
    init(
        next: String?,
        previous: String?,
        results: [NestedProfileWrapperWithToAtPrefix]
    ) {
        self.next = next
        self.previous = previous
        self.results = results
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        next = try container.decodeIfPresent(String.self, forKey: .next) ?? nil
        previous = try container.decodeIfPresent(String.self, forKey: .previous) ?? nil
        results = try container.decodeIfPresent([NestedProfileWrapperWithToAtPrefix].self, forKey: .results) ?? []
    }
}

class NestedProfileWrapperWithToAtPrefix : Decodable {
    private enum CodingKeys: String, CodingKey {
        case to_profile
    }
    
    let nestedProfile: NestedProfile
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        nestedProfile = try container.decodeIfPresent(NestedProfile.self, forKey: .to_profile) ?? NestedProfile()
    }
}
