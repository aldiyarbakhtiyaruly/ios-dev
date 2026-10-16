// =============================================================
//  Station ALMA-7: Rescue Protocol
//  iOS Mobile Development · Module 3 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER CODE section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Use the exact function names from the assignment PDF.
// =============================================================


// MARK: - =================== STARTER CODE ===================
// MARK: - Do not modify anything in this section

typealias Reading = (sensor: String, value: Int)

/// Splits a string at the first occurrence of the separator.
/// splitOnce("O2:87", by: ":") -> ("O2", "87")
/// splitOnce("hello", by: ":") -> nil
func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int      // 1 = evacuated first
    var module: Module?    // nil = in open space
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

// MARK: - ================= END OF STARTER CODE =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each signature when you start working on it.


// MARK: Level 1 · Decoding Telemetry

// 1.1
func parseReading(_ raw: String) -> Reading? {
    guard let parts = splitOnce(raw, by: ":"),
          !parts.0.isEmpty,
          let value = Int(parts.1),
          value >= 0 || parts.0 == "TEMP" else {
        return nil
    }

    return (sensor: parts.0, value: value)
}

print(parseReading("O2:87") as Any)
print(parseReading("TEMP:-12") as Any)
print(parseReading("RAD:-1") as Any)
print(parseReading(":55") as Any)
// 1.2
func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
    var valid: [Reading] = []
    var invalidCount = 0

    for line in lines {
        if let reading = parseReading(line) {
            valid.append(reading)
        } else {
            invalidCount += 1
        }
    }

    return (valid: valid, invalidCount: invalidCount)
}
print(parseLog(["O2:87", "RAD:-1"]).invalidCount)
print(parseLog(["TEMP:-12", "O2:64"]).valid)

let result = parseLog(rawLog)
let A = result.invalidCount

print(result.valid.count)
print(A)
// let A = ...


// MARK: Level 2 · Analysis

// 2.1
func select(_ readings: [Reading],
             where isIncluded: (Reading) -> Bool) -> [Reading] {

     var result: [Reading] = []

     for reading in readings {
         if isIncluded(reading) {
             result.append(reading)
         }
     }

     return result
 }

 func values(of readings: [Reading]) -> [Int] {
     var result: [Int] = []

     for reading in readings {
         result.append(reading.value)
     }

     return result
 }

  let o2Readings = select(parsedLog.valid) {
     $0.sensor == "O2"
 }

 let o2Values = values(of: o2Readings)

 print("O2 readings:", o2Readings)
 print("O2 values:", o2Values)
 print("TEMP values:", values(of: select(parsedLog.valid) {
     $0.sensor == "TEMP"
 }))

// 2.2


func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
    guard let first = values.first else {
        return nil
    }

    var minimum = first
    var maximum = first
    var total = 0

    for value in values {
        if value < minimum {
            minimum = value
        }

        if value > maximum {
            maximum = value
        }

        total += value
    }

    let average = Double(total) / Double(values.count)

    return (min: minimum, max: maximum, average: average)
}

func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
    stats(of: values)
}

print("Stats test:", stats(3, 8, 1) as Any)
print("Empty stats:", stats() as Any)

// Calculate B
let o2Stats = stats(of: o2Values)
let B = Int(o2Stats?.average ?? 0)

print("O2 stats:", o2Stats as Any)
print("B:", B)



let readings = parsedLog.valid


let sorted1 = readings.sorted(by: {
    (a: Reading, b: Reading) -> Bool in
    return a.value > b.value
})


let sorted2 = readings.sorted(by: { a, b in
    return a.value > b.value
})


let sorted3 = readings.sorted(by: { a, b in
    a.value > b.value
})


let sorted4 = readings.sorted(by: {
    $0.value > $1.value
})


let sorted5 = readings.sorted {
    $0.value > $1.value
}

let allEqual =
    values(of: sorted1) == values(of: sorted2) &&
    values(of: sorted2) == values(of: sorted3) &&
    values(of: sorted3) == values(of: sorted4) &&
    values(of: sorted4) == values(of: sorted5)

print("All five sorts match:", allEqual)


print("Sorted values:", values(of: sorted1))
print("First sorted reading:", sorted5.first as Any)



// MARK: Level 3 · Temperature Stabilization


func heatUp(_ t: Int) -> Int {
    return t + 5
}

func coolDown(_ t: Int) -> Int {
    return t - 3
}

func hold(_ t: Int) -> Int {
    return t
}

func chooseProtocol(for temp: Int) -> (Int) -> Int {
    if temp < 18 {
        return heatUp
    } else if temp > 24 {
        return coolDown
    } else {
        return hold
    }
}

print("Heat:", heatUp(10))
print("Heat:", heatUp(20))

print("Cool:", coolDown(30))
print("Cool:", coolDown(25))

print("Hold:", hold(20))
print("Hold:", hold(22))

print("Protocol for 10:", chooseProtocol(for: 10)(10))
print("Protocol for 30:", chooseProtocol(for: 30)(30))
print("Protocol for 20:", chooseProtocol(for: 20)(20))



func runUntilStable(
    from start: Int,
    maxSteps: Int = 10
) -> (finalTemp: Int, steps: Int, isStable: Bool) {

    var temperature = start
    var steps = 0

    while (temperature < 18 || temperature > 24)
            && steps < maxSteps {

        let temperatureProtocol = chooseProtocol(for: temperature)

        temperature = temperatureProtocol(temperature)

        steps += 1
    }

    let isStable = temperature >= 18 && temperature <= 24

    return (
        finalTemp: temperature,
        steps: steps,
        isStable: isStable
    )
}

print("Test 1:", runUntilStable(from: 31))
print("Test 2:", runUntilStable(from: -100, maxSteps: 5))
print("Test 3:", runUntilStable(from: 20))



let tempReadings = select(parsedLog.valid) {
    $0.sensor == "TEMP"
}

let tempValues = values(of: tempReadings)

let tempStats = stats(of: tempValues)

if let lowestTemp = tempStats?.min {
    let result = runUntilStable(from: lowestTemp)
    print("Lowest TEMP:", lowestTemp)
    print("Steps needed:", result.steps)
}

let C = runUntilStable(from: tempStats?.min ?? 0).steps

print("C:", C)


// MARK: Level 4 · The Crew


func oxygenLevel(of member: CrewMember) -> Int? {
    member.module?.oxygenTank?.level
}

print("Timur oxygen:", oxygenLevel(of: crew[0]) as Any)
print("Dana oxygen:", oxygenLevel(of: crew[1]) as Any)



func status(of member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        let moduleName = member.module?.name ?? "open space"
        return "\(member.name): no data (\(moduleName))"
    }

    if level < 20 {
        return "\(member.name): \(level)% CRITICAL"
    } else {
        return "\(member.name): \(level)% OK"
    }
}

print("Status test 1:", status(of: crew[0]))
print("Status test 2:", status(of: crew[1]))

print("=== CREW STATUS ===")

for member in crew {
    print(status(of: member))
}


@discardableResult
func transferOxygen(
    from source: inout Int,
    to target: inout Int,
    amount: Int
) -> Int {

    let actualAmount = max(0, min(amount, source, 100 - target))

    source -= actualAmount
    target += actualAmount

    return actualAmount
}


var testSource = 50
var testTarget = 80

let testTransferred = transferOxygen(
    from: &testSource,
    to: &testTarget,
    amount: 30
)

print("Test transfer:", testTransferred)
print("Test source:", testSource)
print("Test target:", testTarget)


var source2 = 10
var target2 = 95

print("Second transfer:", transferOxygen(
    from: &source2,
    to: &target2,
    amount: 20
))


if let sourceTank = lab.oxygenTank,
   let targetTank = hab.oxygenTank {

    let transferred = transferOxygen(
        from: &sourceTank.level,
        to: &targetTank.level,
        amount: 30
    )

    print("Transferred oxygen:", transferred)
}

// Calculate D
let D = hab.oxygenTank?.level ?? 0

print("Lab oxygen:", lab.oxygenTank?.level as Any)
print("Hab oxygen:", hab.oxygenTank?.level as Any)
print("D:", D)


// Task 4.4 — Evacuation Order

func evacuationOrder(
    _ names: String...,
    roster: [String: CrewMember]
) -> [String] {

    var selectedCrew: [CrewMember] = []

    for name in names {
        guard let member = roster[name] else {
            print("Unknown crew member:", name)
            continue
        }

        selectedCrew.append(member)
    }

    selectedCrew.sort {
        $0.priority < $1.priority
    }

    var result: [String] = []

    for member in selectedCrew {
        result.append(member.name)
    }

    return result
}

// Tests
let order1 = evacuationOrder(
    "Dana",
    "Ghost",
    "Aigerim",
    "Timur",
    roster: roster
)

let order2 = evacuationOrder(
    "Nurlan",
    "Timur",
    roster: roster
)

print("Evacuation order 1:", order1)
print("Evacuation order 2:", order2)

// MARK: Level 5 · The Saboteur's Logbook

// Task 5.1 — Safe Oxygen Report

func reportOxygen(for member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no oxygen data"
    }

    return "\(member.name): \(level)%"
}


print("=== OXYGEN REPORT ===")
print(reportOxygen(for: crew[0]))
print(reportOxygen(for: crew[1]))
print(reportOxygen(for: crew[2]))
print(reportOxygen(for: crew[3]))


// Task 5.2 — Find First Critical Crew Member

func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
        guard let level = oxygenLevel(of: member) else {
            continue
        }

        if level < 20 {
            return member.name
        }
    }

    return nil
}

// Test 1: Existing crew
print("First critical:", firstCritical(in: crew) as Any)

// Test 2: No critical members
let safeCrew = [
    CrewMember(
        name: "Safe Member",
        role: "Engineer",
        priority: 1,
        module: lab
    )
]

print("No critical:", firstCritical(in: safeCrew) as Any)

// Test 3: Two critical members
let criticalModule1 = Module(
    name: "Emergency 1",
    oxygenTank: Tank(level: 10)
)

let criticalModule2 = Module(
    name: "Emergency 2",
    oxygenTank: Tank(level: 5)
)

let criticalCrew = [
    CrewMember(
        name: "First",
        role: "Engineer",
        priority: 1,
        module: criticalModule1
    ),
    CrewMember(
        name: "Second",
        role: "Pilot",
        priority: 2,
        module: criticalModule2
    )
]

print("Two critical:", firstCritical(in: criticalCrew) as Any)


// MARK: - Finale · Launch Code

let launchCode = "\(A)-\(B)-\(C)-\(D)"

print("LAUNCH CODE:", launchCode)

// The saboteur's code is below, commented out (it needs your
// oxygenLevel(of:) to compile). Comment on every problem, then
// write fixed versions and a test that proves the logic bug is gone.

/*
func reportOxygen(for member: CrewMember) -> String {
    let tank = member.module!.oxygenTank!
    return "\(member.name): \(tank.level)%"
}

func firstCritical(in crew: [CrewMember]) -> String {
    var result: String?
    for member in crew {
        if oxygenLevel(of: member)! < 20 {
            result = member.name
        }
    }
    return result!
}
*/


// MARK: Finale · Launch Code

// let launchCode = "\(A)-\(B)-\(C)-\(D)"
// print("LAUNCH CODE: \(launchCode)")


// MARK: Bonus

// func makeAlarm(threshold: Int) -> (Int) -> Bool { }


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. guard let vs if let beyond syntax:

 2. Why can't you pass [Int] to stats(_ values: Int...)?

 3. Why doesn't transferOxygen(from: &x, to: &x, amount: 5) compile?

 4. Why doesn't oxygenLevel(of: dana) ?? "no data" compile?

 5. Full type of chooseProtocol and how to read it:

 Bonus. Where does the alarm counter live after makeAlarm returns?

*/
