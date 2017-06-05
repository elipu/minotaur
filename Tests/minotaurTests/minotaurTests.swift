import XCTest
import LogicKit
@testable import minotaur

struct Wrapper : Equatable, CustomStringConvertible {
  let term : Term

  var description: String {
      return "\(self.term)"
  }

  static func ==(lhs: Wrapper, rhs: Wrapper) -> Bool {
    return (lhs.term).equals (rhs.term)
  }

}

func resultsOf (goal: Goal, variables: [Variable]) -> [[Variable: Wrapper]] {
    var result = [[Variable: Wrapper]] ()
    for s in solve (goal) {
        let solution  = s.reified ()
        var subresult = [Variable: Wrapper] ()
        for v in variables {
            subresult [v] = Wrapper (term: solution [v])
        }
        if !result.contains (where: { x in x == subresult }) {
            result.append (subresult)
        }
    }
    return result
}

class minotaurTests: XCTestCase {

    func testDoors() {
        let from = Variable (named: "from")
        let to   = Variable (named: "to")
        let goal = doors (from: from, to: to)
        XCTAssertEqual(resultsOf (goal: goal, variables: [from, to]).count, 18, "number of doors is incorrect")
    }

    func testEntrance() {
        let location = Variable (named: "location")
        let goal     = entrance (location: location)
        XCTAssertEqual(resultsOf (goal: goal, variables: [location]).count, 2, "number of entrances is incorrect")
    }

    func testExit() {
        let location = Variable (named: "location")
        let goal     = exit (location: location)
        XCTAssertEqual(resultsOf (goal: goal, variables: [location]).count, 2, "number of exits is incorrect")
    }

    func testMinotaur() {
        let location = Variable (named: "location")
        let goal     = minotaur (location: location)
        XCTAssertEqual(resultsOf (goal: goal, variables: [location]).count, 1, "number of minotaurs is incorrect")
    }

    func testPath() {
        let through = Variable (named: "through")
        let goal    = path (from: room (4,4), to: room (3,2), through: through)
        XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 2, "number of paths is incorrect")
    }

    func testBattery() {
        let through = Variable (named: "through")
        let goal    = path (from: room (4,4), to: room (3,2), through: through) &&
                      battery (through: through, level: toNat (7))
        XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 1, "number of paths is incorrect")
    }

    func testLosing() {
        let through = Variable (named: "through")
        let goal    = winning (through: through, level: toNat (6))
        XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 0, "number of paths is incorrect")
    }

    func testWinning() {
        let through = Variable (named: "through")
        let goal    = winning (through: through, level: toNat (7))
        XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 1, "number of paths is incorrect")
    }


/*§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
  §§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§ Additional Tests §§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
  §§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§*/

    // These tests test the other possibilites of paths from an entrance to an exit,
    // encountering the Minotaur on the way and exiting with enough battery.

    /* ======= Tests for the path from Entrance(1,4) to Exit(1,1) ======= */
      func testPath1411() {
          let through = Variable (named: "through")
          let goal    = path (from: room (1,4), to: room (3,2), through: through)
          XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 1, "number of paths is incorrect")
      }

      func testBattery1411() {
          let through = Variable (named: "through")
          let goal    = path (from: room (1,4), to: room (3,2), through: through) &&
                        battery (through: through, level: toNat (9))
          XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 1, "number of paths is incorrect")
      }

      func testLosing1411() {
          let through = Variable (named: "through")
          let goal    = winning (through: through, level: toNat (5))
          XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 0, "number of paths is incorrect")
      }

      func testWinning1411() {
          let through = Variable (named: "through")
          let goal    = winning (through: through, level: toNat (9))
          XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 2, "number of paths is incorrect")
      }
    /* =================================================================== */

    /* ======= Tests for the path from Entrance(1,4) to Exit(4,3) ======= */

      func testPath1443() {
          let through = Variable (named: "through")
          let goal    = path (from: room (1,4), to: room (3,2), through: through)
          XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 1, "number of paths is incorrect")
      }

      func testBattery1443() {
          let through = Variable (named: "through")
          let goal    = path (from: room (1,4), to: room (3,2), through: through) &&
                        battery (through: through, level: toNat (7))
          XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 1, "number of paths is incorrect")
      }

      func testLosing1443() {
          let through = Variable (named: "through")
          let goal    = winning (through: through, level: toNat (5))
          XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 0, "number of paths is incorrect")
      }

      func testWinning1443() {
          let through = Variable (named: "through")
          let goal    = winning (through: through, level: toNat (7))
          XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 1, "number of paths is incorrect")
      }
    /* =================================================================== */

    /* ======= Tests for the path from Entrance(4,4) to Exit(1,1) ======= */
      func testPath4411() {
          let through = Variable (named: "through")
          let goal    = path (from: room (4,4), to: room (3,2), through: through)
          XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 2, "number of paths is incorrect")
      }

      func testBattery4411() {
          let through = Variable (named: "through")
          let goal    = path (from: room (4,4), to: room (3,2), through: through) &&
                        battery (through: through, level: toNat (10))
          XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 2, "number of paths is incorrect")
      }

      func testLosing4411() {
          let through = Variable (named: "through")
          let goal    = winning (through: through, level: toNat (6))
          XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 0, "number of paths is incorrect")
      }

      func testWinning4411() {
          let through = Variable (named: "through")
          let goal    = winning (through: through, level: toNat (10))
          XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 4, "number of paths is incorrect") // 4 because it counts the Exit(4,3) as well
      }
    /* =================================================================== */

//§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
//§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§

        static var allTests : [(String, (minotaurTests) -> () throws -> Void)] {
            return [
                ("testDoors", testDoors),
                ("testEntrance", testEntrance),
                ("testExit", testExit),
                ("testMinotaur", testMinotaur),
                ("testPath", testPath),
                ("testBattery", testBattery),
                ("testLosing", testLosing),
                ("testWinning", testWinning),
                ("testPath1411", testPath1411),
                ("testBattery1411", testBattery1411),
                ("testLosing1411", testLosing1411),
                ("testWinning1411", testWinning1411),
                ("testPath1443", testPath1443),
                ("testBattery1443", testBattery1443),
                ("testLosing1443", testLosing1443),
                ("testWinning1443", testWinning1443),
                ("testPath4411", testPath4411),
                ("testBattery4411", testBattery4411),
                ("testLosing4411", testLosing4411),
                ("testWinning4411", testWinning4411),
            ]
        }
}
