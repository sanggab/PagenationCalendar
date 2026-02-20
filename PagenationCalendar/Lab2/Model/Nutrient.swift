//
//  Nutrient.swift
//  PagenationCalendar
//
//  Created by Gab on 2/20/26.
//

import Foundation

// MARK: - foods[] item

struct DietFood: Codable, Hashable, Identifiable {
    /// 식단 번호
    let dietHeaderNo: Int
    
    /// 음식 이름
    let foodName: String
    
    /// 제공 용량 (추출 못하면 nil 가능)
    let servingSize: Double?
    
    /// 제공 단위 (추출 못하면 nil/빈문자 가능)
    let servingUnit: String?
    
    /// 제공 갯수 (추출 못하면 nil 가능)
    let servingCount: Int?
    
    /// 영양소
    let nutrition: Nutrition
    
    /// 섭취 날짜 원문 (예: "2026-02-10 12:33:32")
    let dietDate: String
    
    /// 식단 구성 음식 수
    let dietFoodCount: Int?
    
    /// 식단 이미지명(푸드렌즈/앨범일 때만 있을 수 있음)
    let dietImageName: String?
    
    /// 대표 음식 이름
    let dietHeaderName: String?
    
    var id: Int { dietHeaderNo }
    
    init(
        dietHeaderNo: Int,
        foodName: String,
        servingSize: Double? = nil,
        servingUnit: String? = nil,
        servingCount: Int? = 1,
        nutrition: Nutrition = .zero,
        dietDate: String,
        dietFoodCount: Int? = nil,
        dietImageName: String? = nil,
        dietHeaderName: String? = nil
    ) {
        self.dietHeaderNo = dietHeaderNo
        self.foodName = foodName
        self.servingSize = servingSize
        self.servingUnit = servingUnit
        self.servingCount = servingCount
        self.nutrition = nutrition
        self.dietDate = dietDate
        self.dietFoodCount = dietFoodCount
        self.dietImageName = dietImageName
        self.dietHeaderName = dietHeaderName
    }
    
    enum CodingKeys: String, CodingKey {
        case foodName
        case servingSize   = "srvSize"
        case servingUnit   = "srvUnit"
        case servingCount  = "srvCnt"
        case nutrition
        
        case dietHeaderNo  = "dietHdNo"
        case dietDate
        case dietFoodCount = "dietDtCnt"
        case dietImageName = "dietHdImgNm"
        case dietHeaderName = "dietHdNm"
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        
        dietHeaderNo   = c.decodeLosslessInt(forKey: .dietHeaderNo)
        foodName       = (try? c.decode(String.self, forKey: .foodName)) ?? ""
        
        servingSize    = c.decodeLosslessDoubleIfPresent(forKey: .servingSize)
        servingUnit    = c.decodeNonEmptyStringIfPresent(forKey: .servingUnit)
        servingCount   = c.decodeLosslessIntIfPresent(forKey: .servingCount)
        
        nutrition      = (try? c.decode(Nutrition.self, forKey: .nutrition)) ?? Nutrition()
        
        dietDate       = (try? c.decode(String.self, forKey: .dietDate)) ?? ""
        dietFoodCount  = c.decodeLosslessIntIfPresent(forKey: .dietFoodCount)
        dietImageName  = c.decodeNonEmptyStringIfPresent(forKey: .dietImageName)
        dietHeaderName = c.decodeNonEmptyStringIfPresent(forKey: .dietHeaderName)
    }
    
    // (옵션) Date로 쓰고 싶으면:
    static let dietDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return f
    }()
    
    var dietDateValue: Date? {
        Self.dietDateFormatter.date(from: dietDate)
    }
}

// MARK: - nutrition

struct Nutrition: Codable, Hashable {
    /// 총 열량(kcal)
    var energyKcal: Double = 0
    /// 탄수화물(g)
    var carbohydratesG: Double = 0
    /// 단백질(g)
    var proteinG: Double = 0
    /// 지방(g)
    var fatG: Double = 0
    /// 당류(g)
    var sugarG: Double = 0
    /// 나트륨(mg)
    var sodiumMg: Double = 0
    /// 식이섬유(g)
    var fiberG: Double = 0
    /// 포화지방(g)
    var saturatedFatG: Double = 0
    /// 트랜스지방(g)
    var transFatG: Double = 0
    /// 콜레스테롤(mg)
    var cholesterolMg: Double = 0
    
    enum CodingKeys: String, CodingKey {
        case energyKcal       = "nutrntEnergy"
        case carbohydratesG   = "nutrntChocdf"
        case proteinG         = "nutrntProtein"
        case fatG             = "nutrntFat"
        case sugarG           = "nutrntSugar"
        case sodiumMg         = "nutrntNat"
        case fiberG           = "nutrntFibtg"
        case saturatedFatG    = "nutrntSfa"
        case transFatG        = "nutrntTrnfa"
        case cholesterolMg    = "nutrntChole"
    }
    
    static let zero = Nutrition()
    
    init(
        energyKcal: Double = 0,
        carbohydratesG: Double = 0,
        proteinG: Double = 0,
        fatG: Double = 0,
        sugarG: Double = 0,
        sodiumMg: Double = 0,
        fiberG: Double = 0,
        saturatedFatG: Double = 0,
        transFatG: Double = 0,
        cholesterolMg: Double = 0
    ) {
        self.energyKcal = energyKcal
        self.carbohydratesG = carbohydratesG
        self.proteinG = proteinG
        self.fatG = fatG
        self.sugarG = sugarG
        self.sodiumMg = sodiumMg
        self.fiberG = fiberG
        self.saturatedFatG = saturatedFatG
        self.transFatG = transFatG
        self.cholesterolMg = cholesterolMg
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        energyKcal       = c.decodeLosslessDouble(forKey: .energyKcal)
        carbohydratesG   = c.decodeLosslessDouble(forKey: .carbohydratesG)
        proteinG         = c.decodeLosslessDouble(forKey: .proteinG)
        fatG             = c.decodeLosslessDouble(forKey: .fatG)
        sugarG           = c.decodeLosslessDouble(forKey: .sugarG)
        sodiumMg         = c.decodeLosslessDouble(forKey: .sodiumMg)
        fiberG           = c.decodeLosslessDouble(forKey: .fiberG)
        saturatedFatG    = c.decodeLosslessDouble(forKey: .saturatedFatG)
        transFatG        = c.decodeLosslessDouble(forKey: .transFatG)
        cholesterolMg    = c.decodeLosslessDouble(forKey: .cholesterolMg)
    }
}

// MARK: - Lossless decoding helpers (0 / 0.0 / "0.0" 모두 대응)

private extension KeyedDecodingContainer {
    func decodeLosslessDoubleIfPresent(forKey key: Key) -> Double? {
        if let v = try? decodeIfPresent(Double.self, forKey: key) { return v }
        if let v = try? decodeIfPresent(Int.self, forKey: key) { return Double(v) }
        if let s = try? decodeIfPresent(String.self, forKey: key) {
            let t = s.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !t.isEmpty else { return nil }
            return Double(t)
        }
        return nil
    }
    
    func decodeLosslessDouble(forKey key: Key) -> Double {
        decodeLosslessDoubleIfPresent(forKey: key) ?? 0
    }
    
    func decodeLosslessIntIfPresent(forKey key: Key) -> Int? {
        if let v = try? decodeIfPresent(Int.self, forKey: key) { return v }
        if let v = try? decodeIfPresent(Double.self, forKey: key) { return Int(v) }
        if let s = try? decodeIfPresent(String.self, forKey: key) {
            let t = s.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !t.isEmpty else { return nil }
            if let i = Int(t) { return i }
            if let d = Double(t), d.isFinite { return Int(d) }
            return nil
        }
        return nil
    }
    
    func decodeLosslessInt(forKey key: Key) -> Int {
        decodeLosslessIntIfPresent(forKey: key) ?? 0
    }
    
    func decodeNonEmptyStringIfPresent(forKey key: Key) -> String? {
        guard let s = try? decodeIfPresent(String.self, forKey: key) else { return nil }
        let t = s.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }
}

extension DietFood {
    // MARK: - Sample list
    static let samples: [DietFood] = [
        DietFood(
            dietHeaderNo: 14,
            foodName: "돼지고기 삼겹살",
            servingSize: 100,
            servingUnit: "g",
            servingCount: 1,
            nutrition: Nutrition(
                energyKcal: 518,
                carbohydratesG: 0,
                proteinG: 17,
                fatG: 48,
                sugarG: 0,
                sodiumMg: 65,
                fiberG: 0,
                saturatedFatG: 17,
                transFatG: 0.2,
                cholesterolMg: 72
            ),
            dietDate: "2026-02-10 12:33:32",
            dietFoodCount: 3,
            dietImageName: "https://contents-cdn.viewus.co.kr/image/2025/06/CP-2025-0008/image-3ad12b2e-1b73-4430-84bb-cb9c20cf862b.jpeg",
            dietHeaderName: "삼겹살"
        ),
        
        DietFood(
            dietHeaderNo: 15,
            foodName: "딸기 푸딩",
            servingSize: 1,
            servingUnit: "개",
            servingCount: 1,
            nutrition: Nutrition(
                energyKcal: 120,
                carbohydratesG: 19,
                proteinG: 5,
                fatG: 2,
                sugarG: 11,
                sodiumMg: 90,
                fiberG: 0,
                saturatedFatG: 1.2,
                transFatG: 0,
                cholesterolMg: 15
            ),
            dietDate: "2026-02-10 11:32:00",
            dietFoodCount: 1,
            dietImageName: "https://recipe1.ezmember.co.kr/cache/recipe/2017/07/25/547942879fd658fb0ac5d6e0d8e9b8dd1.png",
            dietHeaderName: "딸기 푸딩"
        ),
        
        DietFood(
            dietHeaderNo: 16,
            foodName: "뻬스까또레 파스타 (외 3개)",
            servingSize: 1,
            servingUnit: "인분",
            servingCount: 1,
            nutrition: Nutrition(
                energyKcal: 270,
                carbohydratesG: 82,
                proteinG: 27,
                fatG: 6,
                sugarG: 6,
                sodiumMg: 980,
                fiberG: 5,
                saturatedFatG: 1.8,
                transFatG: 0,
                cholesterolMg: 55
            ),
            dietDate: "2026-02-10 10:40:00",
            dietFoodCount: 4,
            dietImageName: "https://recipe1.ezmember.co.kr/cache/recipe/2020/05/10/52a43b19e57b1d911a0e2784afc392f11.jpg",
            dietHeaderName: "뻬스까또레"
        ),
        
        // OCR/바코드 인식 실패 같은 케이스(영양소/서빙 정보가 비거나 0으로 오는 상황)
        DietFood(
            dietHeaderNo: 17,
            foodName: "인식 x / OCR / 바코드",
            servingSize: nil,
            servingUnit: nil,
            servingCount: 1,
            nutrition: .zero,
            dietDate: "2026-02-10 15:45:00",
            dietFoodCount: 1,
            dietImageName: nil,
            dietHeaderName: "인식 실패"
        )
    ]
}
