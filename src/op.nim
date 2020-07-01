type
  OP*[T] = object of RootObj
    case isOk*: bool
    of true:
      val*: T
    of false:
      error*: string

proc ok*[T](val: T): OP[T] =
  OP[T](isOK: true, val: val)

proc fail*(op: OP, msg: string): OP =
  OP(isOK: false, error: msg)

proc fail*[T](msg: string): OP[T] =
  OP[T](isOK: false, error: msg)

