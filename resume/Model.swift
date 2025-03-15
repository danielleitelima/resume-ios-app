// MARK: - Resume Models
struct Resume: Codable {
    let personalData: PersonalData
    let introduction: Introduction
    let skills: [Skill]
    let experiences: [Experience]
    let languages: [Language]
    let education: [Education]
    let articles: [Article]
}

// New model for code samples
struct CodeSample: Codable {
    let ID: String
    let Name: String
    let Description: String
    let InputSchema: String
    let ThumbnailURL: String
}

struct PersonalData: Codable {
    let name: String
    let description: String
    let location: String
    let photoUrl: String
    let emailAddress: String
    let linkedinUrl: String
    let githubUrl: String
}

struct Introduction: Codable {
    let title: String
    let description: String
}

struct Skill: Codable {
    let description: String
    let imageUrl: String
}

struct Experience: Codable {
    let company: Company
    let roles: [Role]
}

struct Company: Codable {
    let name: String
    let period: String
    let location: String
}

struct Role: Codable {
    let name: String
    let period: String
    let description: String
}

struct Language: Codable {
    let name: String
    let level: Int
    let description: String
    let imageUrl: String
}

struct Education: Codable {
    let title: String
    let institution: String
    let period: String
    let location: String
}

struct Article: Codable {
    // Empty for now as the API returns an empty array
}
