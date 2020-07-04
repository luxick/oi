## :Version: 1.0.0
## :Author: luxick <op@luxick.de>
##
## OP stands for "Operation Result".
##
## This module contains a generic type that can be used as a return type
## for operations that could fail. It adds additional messages to the result.
##
##
## This module improves upon the `options module<https://nim-lang.org/docs/options.html>`_
## in that additional messages can be passed along with the presence or absence of a value.
##
## Basic Usage
## -----------
## .. code-block:: nim
##
##  proc divide(a, b: int): OP[float] =
##    ## This could fail
##    if b == 0:
##      return fail "Cannot divide by zero!"
##    else:
##      return ok a / b   # Wrap the result
##
##  let r = divide(42, 0)
##  assert r.isOk == false
##  assert r.error == "Cannot divide by zero!"

import macros

type
  Either*[A, B] = object
    case isA: bool
    of true:
      a: A
    of false:
      b: B

  OP*[T] = Either[T, string]
    ## Alias of `Either` with a string as error message


template checkA*(self: Either): bool = self.isA
template getA*[A, B](self: Either[A, B]): A = self.a
template getB*[A, B](self: Either[A, B]): B = self.b

proc newEitherA*[A, B](a: A): Either[A, B] {.inline.} =
  Either[A, B](isA: true, a: a)

proc newEitherB*[A, B](b: B): Either[A, B] {.inline.} =
  Either[A, B](isA: false, b: b)

template isOK*(self: OP): bool = checkA(self)
template val*(self: OP): auto = getA(self)
template error*(self: OP): auto = getB(self)

template ok*[T](val: T): OP[T] =
  ## Wraps the given value in a successful operation result.
  newEitherA[T, string](val)

template ok*[T](self: var OP[T], val: T) =
  ## Set the result to the given value
  self = ok val

template fail*[T](O: type OP[T], msg: string): O =
  ## Will create a new operation result with the given error message.
  ## The type for the operation result is given explicitly.
  ##
  ## **See Also:**
  ## - `fail proc<#fail,OP,string>`_
  ## - `fail template<#fail.t,static[string]>`_
  newEitherB[T, string](msg)

template fail*(T: typedesc, msg: string): OP[T] =
  ## Will create a new operation result with the given error message.
  ## The type for the operation result is given explicitly.
  ##
  ## **See Also:**
  ## - `fail proc<#fail,OP,string>`_
  ## - `fail template<#fail.t,static[string]>`_
  newEitherB[T, string](msg)

template fail*(op: OP, msg: string): OP =
  ## Will create a new operation result with the given error message.
  ## The type for the operation result is taken from the `op` argument.
  runnableExamples:
    proc someProc(): OP[int] =
      result.fail "Not implemented!"

    let data = someProc()
    assert data.isOk == false
    assert data.error == "Not implemented!"
  fail(typeof(op), msg)


template fail*(msg: static[string]): auto = fail(typeof(result), msg)