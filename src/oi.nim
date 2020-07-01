type
  Err = string
  OI*[T] = object of RootObj
    case isOk*: bool
    of true:
      val*: T
    of false:
      error*: string

proc ok*[T](val: T): OI[T] =
  OI[T](isOK: true, val: val)

proc fail*(oi: OI, msg: string): OI =
  OI(isOK: false, error: msg)

proc fail*[T](msg: string): OI[T] =
  OI[T](isOK: false, error: msg)
