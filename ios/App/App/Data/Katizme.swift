import Foundation

struct Katizma {
    let broj: Int
    let opseg: String
    let psalmi: [Int]
}

// The 20 katizme — traditional Orthodox liturgical division of the Psalter
let katizme: [Katizma] = [
    Katizma(broj: 1, opseg: "1–8", psalmi: [1, 2, 3, 4, 5, 6, 7, 8]),
    Katizma(broj: 2, opseg: "9–16", psalmi: [9, 10, 11, 12, 13, 14, 15, 16]),
    Katizma(broj: 3, opseg: "17–23", psalmi: [17, 18, 19, 20, 21, 22, 23]),
    Katizma(broj: 4, opseg: "24–31", psalmi: [24, 25, 26, 27, 28, 29, 30, 31]),
    Katizma(broj: 5, opseg: "32–36", psalmi: [32, 33, 34, 35, 36]),
    Katizma(broj: 6, opseg: "37–45", psalmi: [37, 38, 39, 40, 41, 42, 43, 44, 45]),
    Katizma(broj: 7, opseg: "46–54", psalmi: [46, 47, 48, 49, 50, 51, 52, 53, 54]),
    Katizma(broj: 8, opseg: "55–63", psalmi: [55, 56, 57, 58, 59, 60, 61, 62, 63]),
    Katizma(broj: 9, opseg: "64–69", psalmi: [64, 65, 66, 67, 68, 69]),
    Katizma(broj: 10, opseg: "70–76", psalmi: [70, 71, 72, 73, 74, 75, 76]),
    Katizma(broj: 11, opseg: "77–84", psalmi: [77, 78, 79, 80, 81, 82, 83, 84]),
    Katizma(broj: 12, opseg: "85–90", psalmi: [85, 86, 87, 88, 89, 90]),
    Katizma(broj: 13, opseg: "91–100", psalmi: [91, 92, 93, 94, 95, 96, 97, 98, 99, 100]),
    Katizma(broj: 14, opseg: "101–104", psalmi: [101, 102, 103, 104]),
    Katizma(broj: 15, opseg: "105–108", psalmi: [105, 106, 107, 108]),
    Katizma(broj: 16, opseg: "109–117", psalmi: [109, 110, 111, 112, 113, 114, 115, 116, 117]),
    Katizma(broj: 17, opseg: "118", psalmi: [118]),
    Katizma(broj: 18, opseg: "119–133", psalmi: [119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133]),
    Katizma(broj: 19, opseg: "134–142", psalmi: [134, 135, 136, 137, 138, 139, 140, 141, 142]),
    Katizma(broj: 20, opseg: "143–150", psalmi: [143, 144, 145, 146, 147, 148, 149, 150]),
]
