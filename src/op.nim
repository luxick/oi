## This module contains a generic type that can be used as a return type
## for operations that could fail. It adds additional messages to the result.
##
## OP stands for "Operation result".

type
  OP*[T] = object of RootObj
    ## Object to wrap the result of an operation
    ##
    ## - `isOk`: Indicates if the operation was successful
    ## - `val`: If successful, this will hold the real result value
    ## - `error`: Otherwise this will hold an error message
    case isOk*: bool
    of true:
      val*: T
    of false:
      error*: string

proc ok*[T](val: T): OP[T] =
  ## Wraps the given value in a successful operation result.
  OP[T](isOK: true, val: val)

proc fail*(op: OP, msg: string): OP =
  ## Will create a new operation result with the given error message.
  ## The type for the operation result is taken from the `op` argument.
  runnableExamples:
    proc someProc(): OP[int] =
      result.fail "Not implemented!"

    let data = someProc()
    assert data.isOk == false
    assert data.error == "Not implemented!"
  OP(isOK: false, error: msg)

proc fail*[T](msg: string): OP[T] =
  ## Will create a new operation result with the given error message.
  ## The type for the operation result is given explicitly.
  ##
  ## **See Also:**
  ## - `fail proc
  ##   <#fail,OP,string>`_
  runnableExamples:
    let res = fail[seq[float]] "Something is wrong!"
    assert res.isOk == false
    assert res.error == "Something is wrong!"
  OP[T](isOK: false, error: msg)

