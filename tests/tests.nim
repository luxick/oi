# To run these tests, simply execute `nimble test`.

import unittest
import op

suite "Basic tests":
  test "Check OK":
    let test = ok 1
    check test.isOk == true

  test "Check fail":
    let test = fail(void, "no data here")
    check test.isOk == false

  test "Check proc results":
    proc createValue: OP[string] =
      let myString = "This is test code!"
      ok myString
    let data = createValue()
    check data.isOk
    check data.val == "This is test code!"

  test "Check failing result proc":
    proc someProc(): OP[int] =
      result.fail "Not implemented!"

    let data = someProc()
    assert data.isOk == false
    assert data.error == "Not implemented!"

  test "Check failing typedesc proc ":
    proc someProc(): OP[int] =
      op.fail(int, "Not implemented!")

    let data = someProc()
    assert data.isOk == false
    assert data.error == "Not implemented!"

  test "Check failing type param proc ":
    proc someProc(): OP[int] =
      fail(int, "Not implemented!")

    let data = someProc()
    assert data.isOk == false
    assert data.error == "Not implemented!"

  test "Check changing result":
    proc checker(): OP[int] =
      result = ok 42
      # something happend here
      result = result.fail "data got corrupted"

    let data = checker()
    check data.isOk == false
    check data.error == "data got corrupted"

  test "Check divider proc":
    proc divide(a, b: int): OP[float] =
      if b == 0:
        return fail(float, "Cannot divide by zero!")
      else:
        return ok a / b

    let
      a = 42
      b = 0
    let r = divide(a, b)
    check r.isOk == false
    check r.error == "Cannot divide by zero!"

  test "Check implicit fail type":
    proc divide(a, b: int): OP[float] =
      if b == 0:
        return fail "Cannot divide by zero!"
      else:
        return ok a / b

    let r = divide(1, 0)
    check r.isOk == false
    check r.error == "Cannot divide by zero!"

  test "Check type of impolicit fail":
      proc divide(a, b: int): OP[float] =
        if b == 0:
          return fail "Cannot divide by zero!"
        else:
          return ok a / b

      let r = divide(1, 0)
      check r.isOk == false
      check r.error == "Cannot divide by zero!"
