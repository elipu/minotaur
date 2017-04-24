import LogicKit

let zero = Value (0)

func succ (_ of: Term) -> Map {
    return ["succ": of]
}

func toNat (_ n : Int) -> Term {
    var result : Term = zero
    for _ in 1...n {
        result = succ (result)
    }
    return result
}

struct Position : Equatable, CustomStringConvertible {
    let x : Int
    let y : Int

    var description: String {
        return "\(self.x):\(self.y)"
    }

    static func ==(lhs: Position, rhs: Position) -> Bool {
      return lhs.x == rhs.x && lhs.y == rhs.y
    }

}


// rooms are numbered:
// x:1,y:1 ... x:n,y:1
// ...             ...
// x:1,y:m ... x:n,y:m
func room (_ x: Int, _ y: Int) -> Term {
  return Value (Position (x: x, y: y))
}

func doors (from: Term, to: Term) -> Goal {
    // TODO
    // This function represents the doors of the labyrinth
    // which are illustrated by arrows in labyrinth.pdf.

    return  (from === room(1,4) && to === room(1,3)) ||
            (from === room(1,3) && to === room(1,2)) ||
            (from === room(1,2) && to === room(1,1)) ||
            (from === room(1,2) && to === room(2,2)) ||

            (from === room(2,4) && to === room(2,3)) ||
            (from === room(2,3) && to === room(2,2)) ||
            (from === room(2,3) && to === room(1,3)) ||
            (from === room(2,2) && to === room(3,2)) ||
            (from === room(2,1) && to === room(1,1)) ||

            (from === room(3,4) && to === room(3,3)) ||
            (from === room(3,4) && to === room(2,4)) ||
            (from === room(3,2) && to === room(3,3)) ||
            (from === room(3,2) && to === room(4,2)) ||
            (from === room(3,1) && to === room(2,1)) ||

            (from === room(4,4) && to === room(3,4)) ||
            (from === room(4,2) && to === room(4,3)) ||
            (from === room(4,2) && to === room(4,1)) ||
            (from === room(4,1) && to === room(3,1))
}

func entrance (location: Term) -> Goal {
    // TODO
    // This function represents the entrances of the labyrinth
    // which are illustrated with 'E' in labyrinth.pdf

    return (location === room(1,4)) || (location === room(4,4))
}

func exit (location: Term) -> Goal {
    // TODO
    // This function represents the exits of the labyrinth
    // which are illustrated with 'S' in labyrinth.pdf

    return (location === room(1,1)) || (location === room(4,3))
}

func minotaur (location: Term) -> Goal {
    // TODO
    // This function represents the location of the Minotaur
    // which is illustrated with a painting of a Minotaur in labyrinth.pdf

    return (location === room(3,2))
}

func path (from: Term, to: Term, through: Term) -> Goal {
    // TODO
    // This function makes a relation between the rooms and a path,
    // and fails if there isn't a path between the two rooms or
    // if the through path does not start at from and end at to

    return  (through === List.empty && from === to) ||  /* corrected the error; before: through === List.cons(from, List.empty)
                                                           thought that through was the path from the begining to the end.
                                                           in fact, through was the path between the entrance and the exit */
            // if either we are in the same room "from === to"
            // or we are at the same door "door(from:from, to:to)" thus there is not "through",
            // we stop the search for a path. Otherwise we search for a path
            delayed (fresh{ next in fresh{ trail in ((doors(from: from, to: next)) &&
                                                     (through === List.cons(next,trail)) &&
                                                     (path(from: next, to: to, through: trail)))
                                                     }})
}

func battery (through: Term, level: Term) -> Goal {
    // TODO
    // This function establishes a relation between the hero's cell phone battery level
    // and the path they have chosen to take, and fails if there is not enough battery.

    return  delayed (fresh { l in (level === succ(l)) &&
                                  ((through === List.empty && delayed(fresh {x in level === succ(x)})) ||
                                   delayed (fresh { ro in fresh { thru in fresh { lvl in
                                           (through === List.cons(ro, thru)) &&
                                           (level === succ(lvl)) &&
                                           battery(through: thru, level : lvl)
                                  }}}))
                                })
}

func foundMinotaur (through: Term) -> Goal {
    // This function indicates if the hero has found the Minotaur in the labyrinth

    return delayed(fresh{ ro in fresh{ thru in (through === List.cons(ro, thru)) &&
                                                (minotaur(location: ro) ||
                                                foundMinotaur(through: thru))
                                               }})
}

func winning (through: Term, level: Term) -> Goal {
    // TODO
    // This function returns the possible paths that leads the hero
    // to slaughter the Minotaur and exit the labyrinth with enough battery level

    return fresh{ In in fresh{ Out in entrance(location: In) &&  /* The hero enters the labyrinth */
                                      path(from: In, to: Out, through: through) && /* choses a path */
                                      foundMinotaur(through: through) && /* kills the Minotaur */
                                      battery(through: through, level: level) && /* still has enough battery to exit */
                                      exit(location: Out) /* and exits the labyrinth */
                                      }}
}
