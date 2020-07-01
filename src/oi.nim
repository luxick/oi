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

proc fail*(msg: string): OI[auto] =
  OI[auto](isOK: false, error: msg)
