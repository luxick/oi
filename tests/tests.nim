# To run these tests, simply execute `nimble test`.

import unittest
import op

suite "Basic tests":
  proc divide(a, b: int): OP[float] =
    if b == 0:
      return fail "Cannot divide by zero!"
    else:
      return ok a / b

  test "Check OK":
    let test = ok 1
    check test.isOk == true

  test "Check fail":
    let test = int.fail "no data here"
    check test.isOk == false

  test "Check proc results":
    proc createValue: OP[string] =
      let myString = "This is test code!"
      ok myString
    let r = createValue()
    check r.isOk
    check r.val == "This is test code!"

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

  test "Check divider OK":
      let r = divide(12, 6)
      check r.isOk == true
      check r.val == 2

  test "Check implicit fail type":
    let r = divide(1, 0)
    check r.isOk == false
    check r.error == "Cannot divide by zero!"

  test "Check case":
    let r = divide(1, 2)
    case r.isOK:
    of true:
      check r.val == 0.5
    of false:
      echo r.error

  test "Check hiding of Either":
    let r = divide(1, 2)
    case r.isOK:
    of true:
      check r.val == 0.5
    of false:
      echo r.error

  test "Expect invalid field":
    let r = divide(1, 2)
    expect FieldError:
      echo r.error

  test "Expect in case":
    let r = divide(1, 2)
    case r.isOK:
    of true:
      expect FieldError:
        echo r.error
    of false:
      echo r.error

  # These will not work. How could this be done?
  # test "Expect access before check":
  #     let r = divide(1, 2)
  #     expect FieldError:
  #       echo r.val

  # test "Expect invalid field after check":
  #     let r = divide(1, 2)
  #     if r.isOK:
  #       echo r.error