(module 
  (import "wasi_snapshot_preview1" "fd_write" (func $fd_write (param i32 i32 i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "fd_read" (func $fd_read (param i32 i32 i32 i32) (result i32)))
  (memory $0 100) (export "memory" (memory $0))
  (global (mut i32) i32.const 0) (global (mut i32) i32.const 0) 

  (func $String_len (param i32) (result i32) (local i32)
    loop $label_0
      local.get 0
      i32.load8_u
      if
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        br $label_0
      else
      end
    end
    local.get 1
  )

  (func $String_concat (param i32 i32) (result i32) (local i32 i32)
    global.get 0
    local.set 3
    local.get 0
    local.set 2
    loop $label_2
      local.get 2
      i32.load8_u
      if
        local.get 3
        local.get 2
        i32.load8_u
        i32.store8
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        local.get 2
        i32.const 1
        i32.add
        local.set 2
        br $label_2
      else
      end
    end
    local.get 1
    local.set 2
    loop $label_3
      local.get 2
      i32.load8_u
      if
        local.get 3
        local.get 2
        i32.load8_u
        i32.store8
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        local.get 2
        i32.const 1
        i32.add
        local.set 2
        br $label_3
      else
      end
    end
    loop $label_1
      local.get 3
      i32.const 0
      i32.store8
      local.get 3
      i32.const 4
      i32.rem_s
      i32.const 3
      i32.eq
      if
      else
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        br $label_1
      end
    end
    global.get 0
    local.get 3
    i32.const 1
    i32.add
    global.set 0
  )

  (func $Std_digitToString (param i32) (result i32) 
    global.get 0
    local.get 0
    i32.const 48
    i32.add
    i32.store
    global.get 0
    global.get 0
    i32.const 4
    i32.add
    global.set 0
  )

  (func $Std_readString (result i32) (local i32 i32 i32)
    global.get 1
    if (result i32)
      global.get 1
      i32.load8_u
      i32.const 0
      i32.eq
    else
      i32.const 1
    end
    if
      global.get 0
      i32.const 4096
      i32.add
      global.get 0
      i32.store
      global.get 0
      i32.const 4100
      i32.add
      i32.const 4095
      i32.store
      i32.const 0
      global.get 0
      i32.const 4096
      i32.add
      i32.const 1
      global.get 0
      i32.const 4104
      i32.add
      call $fd_read
      if
        unreachable
      else
      end
      global.get 0
      i32.const 4104
      i32.add
      i32.load
      local.set 0
      global.get 0
      local.get 0
      global.get 0
      i32.add
      global.set 0
      loop $label_7
        global.get 0
        i32.const 0
        i32.store8
        global.get 0
        i32.const 1
        i32.add
        global.set 0
        global.get 0
        i32.const 4
        i32.rem_s
        if
          br $label_7
        else
        end
      end
      global.set 1
    else
    end
    global.get 1
    global.get 1
    local.set 1
    i32.const 0
    local.set 0
    loop $label_4
      local.get 1
      i32.load8_u
      if
        local.get 1
        i32.load8_u
        i32.const 10
        i32.eq
        if
          local.get 1
          i32.const 1
          i32.add
          global.set 1
        else
          local.get 0
          i32.const 1
          i32.add
          local.set 0
          local.get 1
          i32.const 1
          i32.add
          local.set 1
          br $label_4
        end
      else
        local.get 1
        global.set 1
      end
    end
    local.set 1
    global.get 0
    local.set 2
    loop $label_5
      local.get 0
      if
        local.get 2
        local.get 1
        i32.load8_u
        i32.store8
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        local.get 2
        i32.const 1
        i32.add
        local.set 2
        local.get 0
        i32.const 1
        i32.sub
        local.set 0
        br $label_5
      else
      end
    end
    loop $label_6
      local.get 2
      i32.const 0
      i32.store8
      local.get 2
      i32.const 4
      i32.rem_s
      i32.const 3
      i32.eq
      if
      else
        local.get 2
        i32.const 1
        i32.add
        local.set 2
        br $label_6
      end
    end
    global.get 0
    local.get 2
    i32.const 1
    i32.add
    global.set 0
  )

  (func $Std_readInt (result i32) (local i32 i32 i32 i32)
    call $Std_readString
    local.set 1
    local.get 1
    i32.load8_u
    i32.const 45
    i32.eq
    if
      local.get 1
      i32.const 1
      i32.add
      local.set 1
      i32.const 1
      local.set 0
    else
    end
    loop $label_8
      local.get 1
      i32.load8_u
      i32.const 0
      i32.eq
      if
      else
        local.get 3
        i32.const 10
        i32.mul
        local.get 1
        i32.load8_u
        i32.const 48
        i32.sub
        local.set 2
        local.get 2
        i32.const 10
        i32.lt_u
        if (result i32)
          local.get 2
        else
          unreachable
        end
        i32.add
        local.set 3
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        br $label_8
      end
    end
    local.get 0
    if (result i32)
      i32.const 0
      local.get 3
      i32.sub
    else
      local.get 3
    end
  )

  (func $Std_printString (param i32) (result i32) 
    global.get 0
    local.get 0
    i32.store
    global.get 0
    i32.const 4
    i32.add
    local.get 0
    call $String_len
    i32.store
    i32.const 1
    global.get 0
    i32.const 1
    global.get 0
    i32.const 8
    i32.add
    call $fd_write
    if
      unreachable
    else
    end
    global.get 0
    i32.const 8
    i32.add
    i32.load
    global.get 0
    i32.const 12
    i32.add
    i32.const 10
    i32.store
    global.get 0
    global.get 0
    i32.const 12
    i32.add
    i32.store
    global.get 0
    i32.const 4
    i32.add
    i32.const 1
    i32.store
    i32.const 1
    global.get 0
    i32.const 1
    global.get 0
    i32.const 8
    i32.add
    call $fd_write
    if
      unreachable
    else
    end
  )

  (func $Std_printInt (param i32) (result i32) 
    ;;> def printInt(i: Int(32)): Unit :=
    ;;|   printString(intToString(i))
    ;;| end printInt
    ;;> i
    local.get 0
    call $Std_intToString
    call $Std_printString
  )

  (func $Std_printBoolean (param i32) (result i32) 
    ;;> def printBoolean(b: Boolean): Unit :=
    ;;|   printString(booleanToString(b))
    ;;| end printBoolean
    ;;> b
    local.get 0
    call $Std_booleanToString
    call $Std_printString
  )

  (func $Std_intToString (param i32) (result i32) (local i32 i32)
    ;;> def intToString(i: Int(32)): String :=
    ;;|   (if((i < 0)) then
    ;;|     ("-" ++ intToString(-(i)))
    ;;|   else
    ;;|     (
    ;;|       val rem: Int(32) =
    ;;|         (i % 10);
    ;;|       val div: Int(32) =
    ;;|         (i / 10);
    ;;|       (if((div == 0)) then
    ;;|         digitToString(rem)
    ;;|       else
    ;;|         (intToString(div) ++ digitToString(rem))
    ;;|       end if)
    ;;|     )
    ;;|   end if)
    ;;| end intToString
    ;;> i
    local.get 0
    ;;> 0
    i32.const 0
    i32.lt_s
    if (result i32)
      ;;> "-"
      ;;> mkString: -
      global.get 0
      i32.const 0
      i32.add
      i32.const 45
      i32.store8
      global.get 0
      i32.const 1
      i32.add
      i32.const 0
      i32.store8
      global.get 0
      i32.const 2
      i32.add
      i32.const 0
      i32.store8
      global.get 0
      i32.const 3
      i32.add
      i32.const 0
      i32.store8
      global.get 0
      global.get 0
      i32.const 4
      i32.add
      global.set 0
      ;;> -(i)
      i32.const 0
      ;;> i
      local.get 0
      i32.sub
      call $Std_intToString
      call $String_concat
    else
      ;;> (
      ;;|   val rem: Int(32) =
      ;;|     (i % 10);
      ;;|   val div: Int(32) =
      ;;|     (i / 10);
      ;;|   (if((div == 0)) then
      ;;|     digitToString(rem)
      ;;|   else
      ;;|     (intToString(div) ++ digitToString(rem))
      ;;|   end if)
      ;;| )
      ;;> i
      local.get 0
      ;;> 10
      i32.const 10
      i32.rem_s
      local.set 1
      ;;> (
      ;;|   val div: Int(32) =
      ;;|     (i / 10);
      ;;|   (if((div == 0)) then
      ;;|     digitToString(rem)
      ;;|   else
      ;;|     (intToString(div) ++ digitToString(rem))
      ;;|   end if)
      ;;| )
      ;;> i
      local.get 0
      ;;> 10
      i32.const 10
      i32.div_s
      local.set 2
      ;;> div
      local.get 2
      ;;> 0
      i32.const 0
      i32.eq
      if (result i32)
        ;;> rem
        local.get 1
        call $Std_digitToString
      else
        ;;> div
        local.get 2
        call $Std_intToString
        ;;> rem
        local.get 1
        call $Std_digitToString
        call $String_concat
      end
    end
  )

  (func $Std_booleanToString (param i32) (result i32) 
    ;;> def booleanToString(b: Boolean): String :=
    ;;|   (if(b) then
    ;;|     "true"
    ;;|   else
    ;;|     "false"
    ;;|   end if)
    ;;| end booleanToString
    ;;> b
    local.get 0
    if (result i32)
      ;;> "true"
      ;;> mkString: true
      global.get 0
      i32.const 0
      i32.add
      i32.const 116
      i32.store8
      global.get 0
      i32.const 1
      i32.add
      i32.const 114
      i32.store8
      global.get 0
      i32.const 2
      i32.add
      i32.const 117
      i32.store8
      global.get 0
      i32.const 3
      i32.add
      i32.const 101
      i32.store8
      global.get 0
      i32.const 4
      i32.add
      i32.const 0
      i32.store8
      global.get 0
      i32.const 5
      i32.add
      i32.const 0
      i32.store8
      global.get 0
      i32.const 6
      i32.add
      i32.const 0
      i32.store8
      global.get 0
      i32.const 7
      i32.add
      i32.const 0
      i32.store8
      global.get 0
      global.get 0
      i32.const 8
      i32.add
      global.set 0
    else
      ;;> "false"
      ;;> mkString: false
      global.get 0
      i32.const 0
      i32.add
      i32.const 102
      i32.store8
      global.get 0
      i32.const 1
      i32.add
      i32.const 97
      i32.store8
      global.get 0
      i32.const 2
      i32.add
      i32.const 108
      i32.store8
      global.get 0
      i32.const 3
      i32.add
      i32.const 115
      i32.store8
      global.get 0
      i32.const 4
      i32.add
      i32.const 101
      i32.store8
      global.get 0
      i32.const 5
      i32.add
      i32.const 0
      i32.store8
      global.get 0
      i32.const 6
      i32.add
      i32.const 0
      i32.store8
      global.get 0
      i32.const 7
      i32.add
      i32.const 0
      i32.store8
      global.get 0
      global.get 0
      i32.const 8
      i32.add
      global.set 0
    end
  )

  (func $O_isDefined (param i32) (result i32) (local i32 i32)
    ;;> def isDefined(o: Option): Boolean :=
    ;;|   o match {
    ;;|     case None() =>
    ;;|       false
    ;;|     case _ =>
    ;;|       true
    ;;|   }
    ;;| end isDefined
    ;;> o match {
    ;;|   case None() =>
    ;;|     false
    ;;|   case _ =>
    ;;|     true
    ;;| }
    ;;> o
    local.get 0
    local.set 1
    local.get 1
    ;;> None()
    local.set 2
    local.get 2
    i32.load
    i32.const 0
    i32.eq
    if (result i32)
      ;;> false
      i32.const 0
    else
      local.get 1
      ;;> _
      drop
      i32.const 1
      if (result i32)
        ;;> true
        i32.const 1
      else
        unreachable
      end
    end
  )

  (func $O_get (param i32) (result i32) (local i32 i32 i32 i32)
    ;;> def get(o: Option): Int(32) :=
    ;;|   o match {
    ;;|     case Some(i) =>
    ;;|       i
    ;;|     case None() =>
    ;;|       error("get(None)")
    ;;|   }
    ;;| end get
    ;;> o match {
    ;;|   case Some(i) =>
    ;;|     i
    ;;|   case None() =>
    ;;|     error("get(None)")
    ;;| }
    ;;> o
    local.get 0
    local.set 1
    local.get 1
    ;;> Some(i)
    local.set 3
    local.get 3
    i32.load
    i32.const 1
    i32.eq
    local.get 3
    ;;> adtField index: 0
    i32.const 4
    i32.add
    i32.load
    ;;> i
    local.set 4
    i32.const 1
    i32.and
    if (result i32)
      ;;> i
      local.get 4
    else
      local.get 1
      ;;> None()
      local.set 2
      local.get 2
      i32.load
      i32.const 0
      i32.eq
      if (result i32)
        ;;> error("get(None)")
        ;;> "get(None)"
        ;;> mkString: get(None)
        global.get 0
        i32.const 0
        i32.add
        i32.const 103
        i32.store8
        global.get 0
        i32.const 1
        i32.add
        i32.const 101
        i32.store8
        global.get 0
        i32.const 2
        i32.add
        i32.const 116
        i32.store8
        global.get 0
        i32.const 3
        i32.add
        i32.const 40
        i32.store8
        global.get 0
        i32.const 4
        i32.add
        i32.const 78
        i32.store8
        global.get 0
        i32.const 5
        i32.add
        i32.const 111
        i32.store8
        global.get 0
        i32.const 6
        i32.add
        i32.const 110
        i32.store8
        global.get 0
        i32.const 7
        i32.add
        i32.const 101
        i32.store8
        global.get 0
        i32.const 8
        i32.add
        i32.const 41
        i32.store8
        global.get 0
        i32.const 9
        i32.add
        i32.const 0
        i32.store8
        global.get 0
        i32.const 10
        i32.add
        i32.const 0
        i32.store8
        global.get 0
        i32.const 11
        i32.add
        i32.const 0
        i32.store8
        global.get 0
        global.get 0
        i32.const 12
        i32.add
        global.set 0
        call $Std_printString
        unreachable
      else
        unreachable
      end
    end
  )

  (func $O_getOrElse (param i32 i32) (result i32) (local i32 i32 i32 i32)
    ;;> def getOrElse(o: Option, i: Int(32)): Int(32) :=
    ;;|   o match {
    ;;|     case None() =>
    ;;|       i
    ;;|     case Some(oo) =>
    ;;|       oo
    ;;|   }
    ;;| end getOrElse
    ;;> o match {
    ;;|   case None() =>
    ;;|     i
    ;;|   case Some(oo) =>
    ;;|     oo
    ;;| }
    ;;> o
    local.get 0
    local.set 2
    local.get 2
    ;;> None()
    local.set 5
    local.get 5
    i32.load
    i32.const 0
    i32.eq
    if (result i32)
      ;;> i
      local.get 1
    else
      local.get 2
      ;;> Some(oo)
      local.set 3
      local.get 3
      i32.load
      i32.const 1
      i32.eq
      local.get 3
      ;;> adtField index: 0
      i32.const 4
      i32.add
      i32.load
      ;;> oo
      local.set 4
      i32.const 1
      i32.and
      if (result i32)
        ;;> oo
        local.get 4
      else
        unreachable
      end
    end
  )

  (func $O_orElse (param i32 i32) (result i32) (local i32 i32 i32)
    ;;> def orElse(o1: Option, o2: Option): Option :=
    ;;|   o1 match {
    ;;|     case Some(_) =>
    ;;|       o1
    ;;|     case None() =>
    ;;|       o2
    ;;|   }
    ;;| end orElse
    ;;> o1 match {
    ;;|   case Some(_) =>
    ;;|     o1
    ;;|   case None() =>
    ;;|     o2
    ;;| }
    ;;> o1
    local.get 0
    local.set 2
    local.get 2
    ;;> Some(_)
    local.set 4
    local.get 4
    i32.load
    i32.const 1
    i32.eq
    local.get 4
    ;;> adtField index: 0
    i32.const 4
    i32.add
    i32.load
    ;;> _
    drop
    i32.const 1
    i32.and
    if (result i32)
      ;;> o1
      local.get 0
    else
      local.get 2
      ;;> None()
      local.set 3
      local.get 3
      i32.load
      i32.const 0
      i32.eq
      if (result i32)
        ;;> o2
        local.get 1
      else
        unreachable
      end
    end
  )

  (func $O_toList (param i32) (result i32) (local i32 i32 i32 i32 i32 i32 i32)
    ;;> def toList(o: Option): List :=
    ;;|   o match {
    ;;|     case Some(i) =>
    ;;|       Cons(i, Nil())
    ;;|     case None() =>
    ;;|       Nil()
    ;;|   }
    ;;| end toList
    ;;> o match {
    ;;|   case Some(i) =>
    ;;|     Cons(i, Nil())
    ;;|   case None() =>
    ;;|     Nil()
    ;;| }
    ;;> o
    local.get 0
    local.set 1
    local.get 1
    ;;> Some(i)
    local.set 4
    local.get 4
    i32.load
    i32.const 1
    i32.eq
    local.get 4
    ;;> adtField index: 0
    i32.const 4
    i32.add
    i32.load
    ;;> i
    local.set 5
    i32.const 1
    i32.and
    if (result i32)
      ;;> Cons(i, Nil())
      global.get 0
      local.set 6
      global.get 0
      i32.const 12
      i32.add
      global.set 0
      local.get 6
      i32.const 1
      i32.store
      local.get 6
      i32.const 4
      i32.add
      ;;> i
      local.get 5
      i32.store
      local.get 6
      i32.const 8
      i32.add
      ;;> Nil()
      global.get 0
      local.set 7
      global.get 0
      i32.const 4
      i32.add
      global.set 0
      local.get 7
      i32.const 0
      i32.store
      local.get 7
      i32.store
      local.get 6
    else
      local.get 1
      ;;> None()
      local.set 2
      local.get 2
      i32.load
      i32.const 0
      i32.eq
      if (result i32)
        ;;> Nil()
        global.get 0
        local.set 3
        global.get 0
        i32.const 4
        i32.add
        global.set 0
        local.get 3
        i32.const 0
        i32.store
        local.get 3
      else
        unreachable
      end
    end
  )

  (func $L_isEmpty (param i32) (result i32) (local i32 i32)
    ;;> def isEmpty(l: List): Boolean :=
    ;;|   l match {
    ;;|     case Nil() =>
    ;;|       true
    ;;|     case _ =>
    ;;|       false
    ;;|   }
    ;;| end isEmpty
    ;;> l match {
    ;;|   case Nil() =>
    ;;|     true
    ;;|   case _ =>
    ;;|     false
    ;;| }
    ;;> l
    local.get 0
    local.set 1
    local.get 1
    ;;> Nil()
    local.set 2
    local.get 2
    i32.load
    i32.const 0
    i32.eq
    if (result i32)
      ;;> true
      i32.const 1
    else
      local.get 1
      ;;> _
      drop
      i32.const 1
      if (result i32)
        ;;> false
        i32.const 0
      else
        unreachable
      end
    end
  )

  (func $L_length (param i32) (result i32) (local i32 i32 i32 i32)
    ;;> def length(l: List): Int(32) :=
    ;;|   l match {
    ;;|     case Nil() =>
    ;;|       0
    ;;|     case Cons(_, t) =>
    ;;|       (1 + length(t))
    ;;|   }
    ;;| end length
    ;;> l match {
    ;;|   case Nil() =>
    ;;|     0
    ;;|   case Cons(_, t) =>
    ;;|     (1 + length(t))
    ;;| }
    ;;> l
    local.get 0
    local.set 1
    local.get 1
    ;;> Nil()
    local.set 4
    local.get 4
    i32.load
    i32.const 0
    i32.eq
    if (result i32)
      ;;> 0
      i32.const 0
    else
      local.get 1
      ;;> Cons(_, t)
      local.set 2
      local.get 2
      i32.load
      i32.const 1
      i32.eq
      local.get 2
      ;;> adtField index: 0
      i32.const 4
      i32.add
      i32.load
      ;;> _
      drop
      i32.const 1
      i32.and
      local.get 2
      ;;> adtField index: 1
      i32.const 8
      i32.add
      i32.load
      ;;> t
      local.set 3
      i32.const 1
      i32.and
      if (result i32)
        ;;> 1
        i32.const 1
        ;;> t
        local.get 3
        call $L_length
        i32.add
      else
        unreachable
      end
    end
  )

  (func $L_head (param i32) (result i32) (local i32 i32 i32 i32)
    ;;> def head(l: List): Int(32) :=
    ;;|   l match {
    ;;|     case Cons(h, _) =>
    ;;|       h
    ;;|     case Nil() =>
    ;;|       error("head(Nil)")
    ;;|   }
    ;;| end head
    ;;> l match {
    ;;|   case Cons(h, _) =>
    ;;|     h
    ;;|   case Nil() =>
    ;;|     error("head(Nil)")
    ;;| }
    ;;> l
    local.get 0
    local.set 1
    local.get 1
    ;;> Cons(h, _)
    local.set 3
    local.get 3
    i32.load
    i32.const 1
    i32.eq
    local.get 3
    ;;> adtField index: 0
    i32.const 4
    i32.add
    i32.load
    ;;> h
    local.set 4
    i32.const 1
    i32.and
    local.get 3
    ;;> adtField index: 1
    i32.const 8
    i32.add
    i32.load
    ;;> _
    drop
    i32.const 1
    i32.and
    if (result i32)
      ;;> h
      local.get 4
    else
      local.get 1
      ;;> Nil()
      local.set 2
      local.get 2
      i32.load
      i32.const 0
      i32.eq
      if (result i32)
        ;;> error("head(Nil)")
        ;;> "head(Nil)"
        ;;> mkString: head(Nil)
        global.get 0
        i32.const 0
        i32.add
        i32.const 104
        i32.store8
        global.get 0
        i32.const 1
        i32.add
        i32.const 101
        i32.store8
        global.get 0
        i32.const 2
        i32.add
        i32.const 97
        i32.store8
        global.get 0
        i32.const 3
        i32.add
        i32.const 100
        i32.store8
        global.get 0
        i32.const 4
        i32.add
        i32.const 40
        i32.store8
        global.get 0
        i32.const 5
        i32.add
        i32.const 78
        i32.store8
        global.get 0
        i32.const 6
        i32.add
        i32.const 105
        i32.store8
        global.get 0
        i32.const 7
        i32.add
        i32.const 108
        i32.store8
        global.get 0
        i32.const 8
        i32.add
        i32.const 41
        i32.store8
        global.get 0
        i32.const 9
        i32.add
        i32.const 0
        i32.store8
        global.get 0
        i32.const 10
        i32.add
        i32.const 0
        i32.store8
        global.get 0
        i32.const 11
        i32.add
        i32.const 0
        i32.store8
        global.get 0
        global.get 0
        i32.const 12
        i32.add
        global.set 0
        call $Std_printString
        unreachable
      else
        unreachable
      end
    end
  )

  (func $L_headOption (param i32) (result i32) (local i32 i32 i32 i32 i32 i32)
    ;;> def headOption(l: List): Option :=
    ;;|   l match {
    ;;|     case Cons(h, _) =>
    ;;|       Some(h)
    ;;|     case Nil() =>
    ;;|       None()
    ;;|   }
    ;;| end headOption
    ;;> l match {
    ;;|   case Cons(h, _) =>
    ;;|     Some(h)
    ;;|   case Nil() =>
    ;;|     None()
    ;;| }
    ;;> l
    local.get 0
    local.set 1
    local.get 1
    ;;> Cons(h, _)
    local.set 4
    local.get 4
    i32.load
    i32.const 1
    i32.eq
    local.get 4
    ;;> adtField index: 0
    i32.const 4
    i32.add
    i32.load
    ;;> h
    local.set 5
    i32.const 1
    i32.and
    local.get 4
    ;;> adtField index: 1
    i32.const 8
    i32.add
    i32.load
    ;;> _
    drop
    i32.const 1
    i32.and
    if (result i32)
      ;;> Some(h)
      global.get 0
      local.set 6
      global.get 0
      i32.const 8
      i32.add
      global.set 0
      local.get 6
      i32.const 1
      i32.store
      local.get 6
      i32.const 4
      i32.add
      ;;> h
      local.get 5
      i32.store
      local.get 6
    else
      local.get 1
      ;;> Nil()
      local.set 2
      local.get 2
      i32.load
      i32.const 0
      i32.eq
      if (result i32)
        ;;> None()
        global.get 0
        local.set 3
        global.get 0
        i32.const 4
        i32.add
        global.set 0
        local.get 3
        i32.const 0
        i32.store
        local.get 3
      else
        unreachable
      end
    end
  )

  (func $L_reverse (param i32) (result i32) (local i32)
    ;;> def reverse(l: List): List :=
    ;;|   reverseAcc(l, Nil())
    ;;| end reverse
    ;;> l
    local.get 0
    ;;> Nil()
    global.get 0
    local.set 1
    global.get 0
    i32.const 4
    i32.add
    global.set 0
    local.get 1
    i32.const 0
    i32.store
    local.get 1
    call $L_reverseAcc
  )

  (func $L_reverseAcc (param i32 i32) (result i32) (local i32 i32 i32 i32 i32 i32)
    ;;> def reverseAcc(l: List, acc: List): List :=
    ;;|   l match {
    ;;|     case Nil() =>
    ;;|       acc
    ;;|     case Cons(h, t) =>
    ;;|       reverseAcc(t, Cons(h, acc))
    ;;|   }
    ;;| end reverseAcc
    ;;> l match {
    ;;|   case Nil() =>
    ;;|     acc
    ;;|   case Cons(h, t) =>
    ;;|     reverseAcc(t, Cons(h, acc))
    ;;| }
    ;;> l
    local.get 0
    local.set 2
    local.get 2
    ;;> Nil()
    local.set 7
    local.get 7
    i32.load
    i32.const 0
    i32.eq
    if (result i32)
      ;;> acc
      local.get 1
    else
      local.get 2
      ;;> Cons(h, t)
      local.set 3
      local.get 3
      i32.load
      i32.const 1
      i32.eq
      local.get 3
      ;;> adtField index: 0
      i32.const 4
      i32.add
      i32.load
      ;;> h
      local.set 4
      i32.const 1
      i32.and
      local.get 3
      ;;> adtField index: 1
      i32.const 8
      i32.add
      i32.load
      ;;> t
      local.set 5
      i32.const 1
      i32.and
      if (result i32)
        ;;> t
        local.get 5
        ;;> Cons(h, acc)
        global.get 0
        local.set 6
        global.get 0
        i32.const 12
        i32.add
        global.set 0
        local.get 6
        i32.const 1
        i32.store
        local.get 6
        i32.const 4
        i32.add
        ;;> h
        local.get 4
        i32.store
        local.get 6
        i32.const 8
        i32.add
        ;;> acc
        local.get 1
        i32.store
        local.get 6
        call $L_reverseAcc
      else
        unreachable
      end
    end
  )

  (func $L_indexOf (param i32 i32) (result i32) (local i32 i32 i32 i32 i32 i32)
    ;;> def indexOf(l: List, i: Int(32)): Int(32) :=
    ;;|   l match {
    ;;|     case Nil() =>
    ;;|       -(1)
    ;;|     case Cons(h, t) =>
    ;;|       (if((h == i)) then
    ;;|         0
    ;;|       else
    ;;|         (
    ;;|           val rec: Int(32) =
    ;;|             indexOf(t, i);
    ;;|           (if((0 <= rec)) then
    ;;|             (rec + 1)
    ;;|           else
    ;;|             -(1)
    ;;|           end if)
    ;;|         )
    ;;|       end if)
    ;;|   }
    ;;| end indexOf
    ;;> l match {
    ;;|   case Nil() =>
    ;;|     -(1)
    ;;|   case Cons(h, t) =>
    ;;|     (if((h == i)) then
    ;;|       0
    ;;|     else
    ;;|       (
    ;;|         val rec: Int(32) =
    ;;|           indexOf(t, i);
    ;;|         (if((0 <= rec)) then
    ;;|           (rec + 1)
    ;;|         else
    ;;|           -(1)
    ;;|         end if)
    ;;|       )
    ;;|     end if)
    ;;| }
    ;;> l
    local.get 0
    local.set 2
    local.get 2
    ;;> Nil()
    local.set 7
    local.get 7
    i32.load
    i32.const 0
    i32.eq
    if (result i32)
      ;;> -(1)
      i32.const 0
      ;;> 1
      i32.const 1
      i32.sub
    else
      local.get 2
      ;;> Cons(h, t)
      local.set 3
      local.get 3
      i32.load
      i32.const 1
      i32.eq
      local.get 3
      ;;> adtField index: 0
      i32.const 4
      i32.add
      i32.load
      ;;> h
      local.set 4
      i32.const 1
      i32.and
      local.get 3
      ;;> adtField index: 1
      i32.const 8
      i32.add
      i32.load
      ;;> t
      local.set 5
      i32.const 1
      i32.and
      if (result i32)
        ;;> h
        local.get 4
        ;;> i
        local.get 1
        i32.eq
        if (result i32)
          ;;> 0
          i32.const 0
        else
          ;;> (
          ;;|   val rec: Int(32) =
          ;;|     indexOf(t, i);
          ;;|   (if((0 <= rec)) then
          ;;|     (rec + 1)
          ;;|   else
          ;;|     -(1)
          ;;|   end if)
          ;;| )
          ;;> t
          local.get 5
          ;;> i
          local.get 1
          call $L_indexOf
          local.set 6
          ;;> 0
          i32.const 0
          ;;> rec
          local.get 6
          i32.le_s
          if (result i32)
            ;;> rec
            local.get 6
            ;;> 1
            i32.const 1
            i32.add
          else
            ;;> -(1)
            i32.const 0
            ;;> 1
            i32.const 1
            i32.sub
          end
        end
      else
        unreachable
      end
    end
  )

  (func $L_range (param i32 i32) (result i32) (local i32 i32)
    ;;> def range(from: Int(32), to: Int(32)): List :=
    ;;|   (if((to < from)) then
    ;;|     Nil()
    ;;|   else
    ;;|     Cons(from, range((from + 1), to))
    ;;|   end if)
    ;;| end range
    ;;> to
    local.get 1
    ;;> from
    local.get 0
    i32.lt_s
    if (result i32)
      ;;> Nil()
      global.get 0
      local.set 2
      global.get 0
      i32.const 4
      i32.add
      global.set 0
      local.get 2
      i32.const 0
      i32.store
      local.get 2
    else
      ;;> Cons(from, range((from + 1), to))
      global.get 0
      local.set 3
      global.get 0
      i32.const 12
      i32.add
      global.set 0
      local.get 3
      i32.const 1
      i32.store
      local.get 3
      i32.const 4
      i32.add
      ;;> from
      local.get 0
      i32.store
      local.get 3
      i32.const 8
      i32.add
      ;;> from
      local.get 0
      ;;> 1
      i32.const 1
      i32.add
      ;;> to
      local.get 1
      call $L_range
      i32.store
      local.get 3
    end
  )

  (func $L_sum (param i32) (result i32) (local i32 i32 i32 i32 i32)
    ;;> def sum(l: List): Int(32) :=
    ;;|   l match {
    ;;|     case Nil() =>
    ;;|       0
    ;;|     case Cons(h, t) =>
    ;;|       (h + sum(t))
    ;;|   }
    ;;| end sum
    ;;> l match {
    ;;|   case Nil() =>
    ;;|     0
    ;;|   case Cons(h, t) =>
    ;;|     (h + sum(t))
    ;;| }
    ;;> l
    local.get 0
    local.set 1
    local.get 1
    ;;> Nil()
    local.set 5
    local.get 5
    i32.load
    i32.const 0
    i32.eq
    if (result i32)
      ;;> 0
      i32.const 0
    else
      local.get 1
      ;;> Cons(h, t)
      local.set 2
      local.get 2
      i32.load
      i32.const 1
      i32.eq
      local.get 2
      ;;> adtField index: 0
      i32.const 4
      i32.add
      i32.load
      ;;> h
      local.set 3
      i32.const 1
      i32.and
      local.get 2
      ;;> adtField index: 1
      i32.const 8
      i32.add
      i32.load
      ;;> t
      local.set 4
      i32.const 1
      i32.and
      if (result i32)
        ;;> h
        local.get 3
        ;;> t
        local.get 4
        call $L_sum
        i32.add
      else
        unreachable
      end
    end
  )

  (func $L_concat (param i32 i32) (result i32) (local i32 i32 i32 i32 i32 i32)
    ;;> def concat(l1: List, l2: List): List :=
    ;;|   l1 match {
    ;;|     case Nil() =>
    ;;|       l2
    ;;|     case Cons(h, t) =>
    ;;|       Cons(h, concat(l1, l2))
    ;;|   }
    ;;| end concat
    ;;> l1 match {
    ;;|   case Nil() =>
    ;;|     l2
    ;;|   case Cons(h, t) =>
    ;;|     Cons(h, concat(l1, l2))
    ;;| }
    ;;> l1
    local.get 0
    local.set 2
    local.get 2
    ;;> Nil()
    local.set 7
    local.get 7
    i32.load
    i32.const 0
    i32.eq
    if (result i32)
      ;;> l2
      local.get 1
    else
      local.get 2
      ;;> Cons(h, t)
      local.set 3
      local.get 3
      i32.load
      i32.const 1
      i32.eq
      local.get 3
      ;;> adtField index: 0
      i32.const 4
      i32.add
      i32.load
      ;;> h
      local.set 4
      i32.const 1
      i32.and
      local.get 3
      ;;> adtField index: 1
      i32.const 8
      i32.add
      i32.load
      ;;> t
      local.set 5
      i32.const 1
      i32.and
      if (result i32)
        ;;> Cons(h, concat(l1, l2))
        global.get 0
        local.set 6
        global.get 0
        i32.const 12
        i32.add
        global.set 0
        local.get 6
        i32.const 1
        i32.store
        local.get 6
        i32.const 4
        i32.add
        ;;> h
        local.get 4
        i32.store
        local.get 6
        i32.const 8
        i32.add
        ;;> l1
        local.get 0
        ;;> l2
        local.get 1
        call $L_concat
        i32.store
        local.get 6
      else
        unreachable
      end
    end
  )

  (func $L_contains (param i32 i32) (result i32) (local i32 i32 i32 i32 i32)
    ;;> def contains(l: List, elem: Int(32)): Boolean :=
    ;;|   l match {
    ;;|     case Nil() =>
    ;;|       false
    ;;|     case Cons(h, t) =>
    ;;|       ((h == elem) || contains(t, elem))
    ;;|   }
    ;;| end contains
    ;;> l match {
    ;;|   case Nil() =>
    ;;|     false
    ;;|   case Cons(h, t) =>
    ;;|     ((h == elem) || contains(t, elem))
    ;;| }
    ;;> l
    local.get 0
    local.set 2
    local.get 2
    ;;> Nil()
    local.set 6
    local.get 6
    i32.load
    i32.const 0
    i32.eq
    if (result i32)
      ;;> false
      i32.const 0
    else
      local.get 2
      ;;> Cons(h, t)
      local.set 3
      local.get 3
      i32.load
      i32.const 1
      i32.eq
      local.get 3
      ;;> adtField index: 0
      i32.const 4
      i32.add
      i32.load
      ;;> h
      local.set 4
      i32.const 1
      i32.and
      local.get 3
      ;;> adtField index: 1
      i32.const 8
      i32.add
      i32.load
      ;;> t
      local.set 5
      i32.const 1
      i32.and
      if (result i32)
        ;;> h
        local.get 4
        ;;> elem
        local.get 1
        i32.eq
        if (result i32)
          i32.const 1
        else
          ;;> t
          local.get 5
          ;;> elem
          local.get 1
          call $L_contains
        end
      else
        unreachable
      end
    end
  )

  (func $L_merge (param i32 i32) (result i32) (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    ;;> def merge(l1: List, l2: List): List :=
    ;;|   l1 match {
    ;;|     case Nil() =>
    ;;|       l2
    ;;|     case Cons(h1, t1) =>
    ;;|       l2 match {
    ;;|         case Nil() =>
    ;;|           l1
    ;;|         case Cons(h2, t2) =>
    ;;|           (if((h1 <= h2)) then
    ;;|             Cons(h1, merge(t1, l2))
    ;;|           else
    ;;|             Cons(h2, merge(l1, t2))
    ;;|           end if)
    ;;|       }
    ;;|   }
    ;;| end merge
    ;;> l1 match {
    ;;|   case Nil() =>
    ;;|     l2
    ;;|   case Cons(h1, t1) =>
    ;;|     l2 match {
    ;;|       case Nil() =>
    ;;|         l1
    ;;|       case Cons(h2, t2) =>
    ;;|         (if((h1 <= h2)) then
    ;;|           Cons(h1, merge(t1, l2))
    ;;|         else
    ;;|           Cons(h2, merge(l1, t2))
    ;;|         end if)
    ;;|     }
    ;;| }
    ;;> l1
    local.get 0
    local.set 2
    local.get 2
    ;;> Nil()
    local.set 13
    local.get 13
    i32.load
    i32.const 0
    i32.eq
    if (result i32)
      ;;> l2
      local.get 1
    else
      local.get 2
      ;;> Cons(h1, t1)
      local.set 3
      local.get 3
      i32.load
      i32.const 1
      i32.eq
      local.get 3
      ;;> adtField index: 0
      i32.const 4
      i32.add
      i32.load
      ;;> h1
      local.set 4
      i32.const 1
      i32.and
      local.get 3
      ;;> adtField index: 1
      i32.const 8
      i32.add
      i32.load
      ;;> t1
      local.set 5
      i32.const 1
      i32.and
      if (result i32)
        ;;> l2 match {
        ;;|   case Nil() =>
        ;;|     l1
        ;;|   case Cons(h2, t2) =>
        ;;|     (if((h1 <= h2)) then
        ;;|       Cons(h1, merge(t1, l2))
        ;;|     else
        ;;|       Cons(h2, merge(l1, t2))
        ;;|     end if)
        ;;| }
        ;;> l2
        local.get 1
        local.set 6
        local.get 6
        ;;> Nil()
        local.set 12
        local.get 12
        i32.load
        i32.const 0
        i32.eq
        if (result i32)
          ;;> l1
          local.get 0
        else
          local.get 6
          ;;> Cons(h2, t2)
          local.set 7
          local.get 7
          i32.load
          i32.const 1
          i32.eq
          local.get 7
          ;;> adtField index: 0
          i32.const 4
          i32.add
          i32.load
          ;;> h2
          local.set 8
          i32.const 1
          i32.and
          local.get 7
          ;;> adtField index: 1
          i32.const 8
          i32.add
          i32.load
          ;;> t2
          local.set 9
          i32.const 1
          i32.and
          if (result i32)
            ;;> h1
            local.get 4
            ;;> h2
            local.get 8
            i32.le_s
            if (result i32)
              ;;> Cons(h1, merge(t1, l2))
              global.get 0
              local.set 10
              global.get 0
              i32.const 12
              i32.add
              global.set 0
              local.get 10
              i32.const 1
              i32.store
              local.get 10
              i32.const 4
              i32.add
              ;;> h1
              local.get 4
              i32.store
              local.get 10
              i32.const 8
              i32.add
              ;;> t1
              local.get 5
              ;;> l2
              local.get 1
              call $L_merge
              i32.store
              local.get 10
            else
              ;;> Cons(h2, merge(l1, t2))
              global.get 0
              local.set 11
              global.get 0
              i32.const 12
              i32.add
              global.set 0
              local.get 11
              i32.const 1
              i32.store
              local.get 11
              i32.const 4
              i32.add
              ;;> h2
              local.get 8
              i32.store
              local.get 11
              i32.const 8
              i32.add
              ;;> l1
              local.get 0
              ;;> t2
              local.get 9
              call $L_merge
              i32.store
              local.get 11
            end
          else
            unreachable
          end
        end
      else
        unreachable
      end
    end
  )

  (func $L_split (param i32) (result i32) (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    ;;> def split(l: List): LPair :=
    ;;|   l match {
    ;;|     case Cons(h1, Cons(h2, t)) =>
    ;;|       (
    ;;|         val rec: LPair =
    ;;|           split(t);
    ;;|         rec match {
    ;;|           case LP(rec1, rec2) =>
    ;;|             LP(Cons(h1, rec1), Cons(h2, rec2))
    ;;|         }
    ;;|       )
    ;;|     case _ =>
    ;;|       LP(l, Nil())
    ;;|   }
    ;;| end split
    ;;> l match {
    ;;|   case Cons(h1, Cons(h2, t)) =>
    ;;|     (
    ;;|       val rec: LPair =
    ;;|         split(t);
    ;;|       rec match {
    ;;|         case LP(rec1, rec2) =>
    ;;|           LP(Cons(h1, rec1), Cons(h2, rec2))
    ;;|       }
    ;;|     )
    ;;|   case _ =>
    ;;|     LP(l, Nil())
    ;;| }
    ;;> l
    local.get 0
    local.set 1
    local.get 1
    ;;> Cons(h1, Cons(h2, t))
    local.set 4
    local.get 4
    i32.load
    i32.const 1
    i32.eq
    local.get 4
    ;;> adtField index: 0
    i32.const 4
    i32.add
    i32.load
    ;;> h1
    local.set 5
    i32.const 1
    i32.and
    local.get 4
    ;;> adtField index: 1
    i32.const 8
    i32.add
    i32.load
    ;;> Cons(h2, t)
    local.set 6
    local.get 6
    i32.load
    i32.const 1
    i32.eq
    local.get 6
    ;;> adtField index: 0
    i32.const 4
    i32.add
    i32.load
    ;;> h2
    local.set 7
    i32.const 1
    i32.and
    local.get 6
    ;;> adtField index: 1
    i32.const 8
    i32.add
    i32.load
    ;;> t
    local.set 8
    i32.const 1
    i32.and
    i32.and
    if (result i32)
      ;;> (
      ;;|   val rec: LPair =
      ;;|     split(t);
      ;;|   rec match {
      ;;|     case LP(rec1, rec2) =>
      ;;|       LP(Cons(h1, rec1), Cons(h2, rec2))
      ;;|   }
      ;;| )
      ;;> t
      local.get 8
      call $L_split
      local.set 9
      ;;> rec match {
      ;;|   case LP(rec1, rec2) =>
      ;;|     LP(Cons(h1, rec1), Cons(h2, rec2))
      ;;| }
      ;;> rec
      local.get 9
      local.set 10
      local.get 10
      ;;> LP(rec1, rec2)
      local.set 11
      local.get 11
      i32.load
      i32.const 0
      i32.eq
      local.get 11
      ;;> adtField index: 0
      i32.const 4
      i32.add
      i32.load
      ;;> rec1
      local.set 12
      i32.const 1
      i32.and
      local.get 11
      ;;> adtField index: 1
      i32.const 8
      i32.add
      i32.load
      ;;> rec2
      local.set 13
      i32.const 1
      i32.and
      if (result i32)
        ;;> LP(Cons(h1, rec1), Cons(h2, rec2))
        global.get 0
        local.set 14
        global.get 0
        i32.const 12
        i32.add
        global.set 0
        local.get 14
        i32.const 0
        i32.store
        local.get 14
        i32.const 4
        i32.add
        ;;> Cons(h1, rec1)
        global.get 0
        local.set 15
        global.get 0
        i32.const 12
        i32.add
        global.set 0
        local.get 15
        i32.const 1
        i32.store
        local.get 15
        i32.const 4
        i32.add
        ;;> h1
        local.get 5
        i32.store
        local.get 15
        i32.const 8
        i32.add
        ;;> rec1
        local.get 12
        i32.store
        local.get 15
        i32.store
        local.get 14
        i32.const 8
        i32.add
        ;;> Cons(h2, rec2)
        global.get 0
        local.set 16
        global.get 0
        i32.const 12
        i32.add
        global.set 0
        local.get 16
        i32.const 1
        i32.store
        local.get 16
        i32.const 4
        i32.add
        ;;> h2
        local.get 7
        i32.store
        local.get 16
        i32.const 8
        i32.add
        ;;> rec2
        local.get 13
        i32.store
        local.get 16
        i32.store
        local.get 14
      else
        unreachable
      end
    else
      local.get 1
      ;;> _
      drop
      i32.const 1
      if (result i32)
        ;;> LP(l, Nil())
        global.get 0
        local.set 2
        global.get 0
        i32.const 12
        i32.add
        global.set 0
        local.get 2
        i32.const 0
        i32.store
        local.get 2
        i32.const 4
        i32.add
        ;;> l
        local.get 0
        i32.store
        local.get 2
        i32.const 8
        i32.add
        ;;> Nil()
        global.get 0
        local.set 3
        global.get 0
        i32.const 4
        i32.add
        global.set 0
        local.get 3
        i32.const 0
        i32.store
        local.get 3
        i32.store
        local.get 2
      else
        unreachable
      end
    end
  )

  (func $L_mergeSort (param i32) (result i32) (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    ;;> def mergeSort(l: List): List :=
    ;;|   l match {
    ;;|     case Nil() =>
    ;;|       l
    ;;|     case Cons(h, Nil()) =>
    ;;|       l
    ;;|     case l =>
    ;;|       split(l) match {
    ;;|         case LP(l1, l2) =>
    ;;|           merge(mergeSort(l1), mergeSort(l2))
    ;;|       }
    ;;|   }
    ;;| end mergeSort
    ;;> l match {
    ;;|   case Nil() =>
    ;;|     l
    ;;|   case Cons(h, Nil()) =>
    ;;|     l
    ;;|   case l =>
    ;;|     split(l) match {
    ;;|       case LP(l1, l2) =>
    ;;|         merge(mergeSort(l1), mergeSort(l2))
    ;;|     }
    ;;| }
    ;;> l
    local.get 0
    local.set 1
    local.get 1
    ;;> Nil()
    local.set 10
    local.get 10
    i32.load
    i32.const 0
    i32.eq
    if (result i32)
      ;;> l
      local.get 0
    else
      local.get 1
      ;;> Cons(h, Nil())
      local.set 7
      local.get 7
      i32.load
      i32.const 1
      i32.eq
      local.get 7
      ;;> adtField index: 0
      i32.const 4
      i32.add
      i32.load
      ;;> h
      local.set 8
      i32.const 1
      i32.and
      local.get 7
      ;;> adtField index: 1
      i32.const 8
      i32.add
      i32.load
      ;;> Nil()
      local.set 9
      local.get 9
      i32.load
      i32.const 0
      i32.eq
      i32.and
      if (result i32)
        ;;> l
        local.get 0
      else
        local.get 1
        ;;> l
        local.set 2
        i32.const 1
        if (result i32)
          ;;> split(l) match {
          ;;|   case LP(l1, l2) =>
          ;;|     merge(mergeSort(l1), mergeSort(l2))
          ;;| }
          ;;> l
          local.get 2
          call $L_split
          local.set 3
          local.get 3
          ;;> LP(l1, l2)
          local.set 4
          local.get 4
          i32.load
          i32.const 0
          i32.eq
          local.get 4
          ;;> adtField index: 0
          i32.const 4
          i32.add
          i32.load
          ;;> l1
          local.set 5
          i32.const 1
          i32.and
          local.get 4
          ;;> adtField index: 1
          i32.const 8
          i32.add
          i32.load
          ;;> l2
          local.set 6
          i32.const 1
          i32.and
          if (result i32)
            ;;> l1
            local.get 5
            call $L_mergeSort
            ;;> l2
            local.get 6
            call $L_mergeSort
            call $L_merge
          else
            unreachable
          end
        else
          unreachable
        end
      end
    end
  )

  (func $L_toString (param i32) (result i32) (local i32 i32 i32)
    ;;> def toString(l: List): String :=
    ;;|   l match {
    ;;|     case Nil() =>
    ;;|       "List()"
    ;;|     case more =>
    ;;|       (("List(" ++ toString1(more)) ++ ")")
    ;;|   }
    ;;| end toString
    ;;> l match {
    ;;|   case Nil() =>
    ;;|     "List()"
    ;;|   case more =>
    ;;|     (("List(" ++ toString1(more)) ++ ")")
    ;;| }
    ;;> l
    local.get 0
    local.set 1
    local.get 1
    ;;> Nil()
    local.set 3
    local.get 3
    i32.load
    i32.const 0
    i32.eq
    if (result i32)
      ;;> "List()"
      ;;> mkString: List()
      global.get 0
      i32.const 0
      i32.add
      i32.const 76
      i32.store8
      global.get 0
      i32.const 1
      i32.add
      i32.const 105
      i32.store8
      global.get 0
      i32.const 2
      i32.add
      i32.const 115
      i32.store8
      global.get 0
      i32.const 3
      i32.add
      i32.const 116
      i32.store8
      global.get 0
      i32.const 4
      i32.add
      i32.const 40
      i32.store8
      global.get 0
      i32.const 5
      i32.add
      i32.const 41
      i32.store8
      global.get 0
      i32.const 6
      i32.add
      i32.const 0
      i32.store8
      global.get 0
      i32.const 7
      i32.add
      i32.const 0
      i32.store8
      global.get 0
      global.get 0
      i32.const 8
      i32.add
      global.set 0
    else
      local.get 1
      ;;> more
      local.set 2
      i32.const 1
      if (result i32)
        ;;> "List("
        ;;> mkString: List(
        global.get 0
        i32.const 0
        i32.add
        i32.const 76
        i32.store8
        global.get 0
        i32.const 1
        i32.add
        i32.const 105
        i32.store8
        global.get 0
        i32.const 2
        i32.add
        i32.const 115
        i32.store8
        global.get 0
        i32.const 3
        i32.add
        i32.const 116
        i32.store8
        global.get 0
        i32.const 4
        i32.add
        i32.const 40
        i32.store8
        global.get 0
        i32.const 5
        i32.add
        i32.const 0
        i32.store8
        global.get 0
        i32.const 6
        i32.add
        i32.const 0
        i32.store8
        global.get 0
        i32.const 7
        i32.add
        i32.const 0
        i32.store8
        global.get 0
        global.get 0
        i32.const 8
        i32.add
        global.set 0
        ;;> more
        local.get 2
        call $L_toString1
        call $String_concat
        ;;> ")"
        ;;> mkString: )
        global.get 0
        i32.const 0
        i32.add
        i32.const 41
        i32.store8
        global.get 0
        i32.const 1
        i32.add
        i32.const 0
        i32.store8
        global.get 0
        i32.const 2
        i32.add
        i32.const 0
        i32.store8
        global.get 0
        i32.const 3
        i32.add
        i32.const 0
        i32.store8
        global.get 0
        global.get 0
        i32.const 4
        i32.add
        global.set 0
        call $String_concat
      else
        unreachable
      end
    end
  )

  (func $L_toString1 (param i32) (result i32) (local i32 i32 i32 i32 i32 i32 i32)
    ;;> def toString1(l: List): String :=
    ;;|   l match {
    ;;|     case Cons(h, Nil()) =>
    ;;|       intToString(h)
    ;;|     case Cons(h, t) =>
    ;;|       ((intToString(h) ++ ", ") ++ toString1(t))
    ;;|   }
    ;;| end toString1
    ;;> l match {
    ;;|   case Cons(h, Nil()) =>
    ;;|     intToString(h)
    ;;|   case Cons(h, t) =>
    ;;|     ((intToString(h) ++ ", ") ++ toString1(t))
    ;;| }
    ;;> l
    local.get 0
    local.set 1
    local.get 1
    ;;> Cons(h, Nil())
    local.set 5
    local.get 5
    i32.load
    i32.const 1
    i32.eq
    local.get 5
    ;;> adtField index: 0
    i32.const 4
    i32.add
    i32.load
    ;;> h
    local.set 6
    i32.const 1
    i32.and
    local.get 5
    ;;> adtField index: 1
    i32.const 8
    i32.add
    i32.load
    ;;> Nil()
    local.set 7
    local.get 7
    i32.load
    i32.const 0
    i32.eq
    i32.and
    if (result i32)
      ;;> h
      local.get 6
      call $Std_intToString
    else
      local.get 1
      ;;> Cons(h, t)
      local.set 2
      local.get 2
      i32.load
      i32.const 1
      i32.eq
      local.get 2
      ;;> adtField index: 0
      i32.const 4
      i32.add
      i32.load
      ;;> h
      local.set 3
      i32.const 1
      i32.and
      local.get 2
      ;;> adtField index: 1
      i32.const 8
      i32.add
      i32.load
      ;;> t
      local.set 4
      i32.const 1
      i32.and
      if (result i32)
        ;;> h
        local.get 3
        call $Std_intToString
        ;;> ", "
        ;;> mkString: , 
        global.get 0
        i32.const 0
        i32.add
        i32.const 44
        i32.store8
        global.get 0
        i32.const 1
        i32.add
        i32.const 32
        i32.store8
        global.get 0
        i32.const 2
        i32.add
        i32.const 0
        i32.store8
        global.get 0
        i32.const 3
        i32.add
        i32.const 0
        i32.store8
        global.get 0
        global.get 0
        i32.const 4
        i32.add
        global.set 0
        call $String_concat
        ;;> t
        local.get 4
        call $L_toString1
        call $String_concat
      else
        unreachable
      end
    end
  )

  (func $L_take (param i32 i32) (result i32) (local i32 i32 i32 i32 i32 i32 i32 i32)
    ;;> def take(l: List, n: Int(32)): List :=
    ;;|   (if((n <= 0)) then
    ;;|     Nil()
    ;;|   else
    ;;|     l match {
    ;;|       case Nil() =>
    ;;|         Nil()
    ;;|       case Cons(h, t) =>
    ;;|         Cons(h, take(t, (n - 1)))
    ;;|     }
    ;;|   end if)
    ;;| end take
    ;;> n
    local.get 1
    ;;> 0
    i32.const 0
    i32.le_s
    if (result i32)
      ;;> Nil()
      global.get 0
      local.set 2
      global.get 0
      i32.const 4
      i32.add
      global.set 0
      local.get 2
      i32.const 0
      i32.store
      local.get 2
    else
      ;;> l match {
      ;;|   case Nil() =>
      ;;|     Nil()
      ;;|   case Cons(h, t) =>
      ;;|     Cons(h, take(t, (n - 1)))
      ;;| }
      ;;> l
      local.get 0
      local.set 3
      local.get 3
      ;;> Nil()
      local.set 8
      local.get 8
      i32.load
      i32.const 0
      i32.eq
      if (result i32)
        ;;> Nil()
        global.get 0
        local.set 9
        global.get 0
        i32.const 4
        i32.add
        global.set 0
        local.get 9
        i32.const 0
        i32.store
        local.get 9
      else
        local.get 3
        ;;> Cons(h, t)
        local.set 4
        local.get 4
        i32.load
        i32.const 1
        i32.eq
        local.get 4
        ;;> adtField index: 0
        i32.const 4
        i32.add
        i32.load
        ;;> h
        local.set 5
        i32.const 1
        i32.and
        local.get 4
        ;;> adtField index: 1
        i32.const 8
        i32.add
        i32.load
        ;;> t
        local.set 6
        i32.const 1
        i32.and
        if (result i32)
          ;;> Cons(h, take(t, (n - 1)))
          global.get 0
          local.set 7
          global.get 0
          i32.const 12
          i32.add
          global.set 0
          local.get 7
          i32.const 1
          i32.store
          local.get 7
          i32.const 4
          i32.add
          ;;> h
          local.get 5
          i32.store
          local.get 7
          i32.const 8
          i32.add
          ;;> t
          local.get 6
          ;;> n
          local.get 1
          ;;> 1
          i32.const 1
          i32.sub
          call $L_take
          i32.store
          local.get 7
        else
          unreachable
        end
      end
    end
  )
  (export "_start" (func $TestLists_main))
  (func $TestLists_main (local i32 i32 i32 i32 i32 i32 i32)
    ;;> (
    ;;|   val l: List =
    ;;|     Cons(5, Cons(-(5), Cons(-(1), Cons(0, Cons(10, Nil())))));
    ;;|   printInt(sum(l));
    ;;|   printString(toString(mergeSort(l)))
    ;;| )
    ;;> Cons(5, Cons(-(5), Cons(-(1), Cons(0, Cons(10, Nil())))))
    global.get 0
    local.set 1
    global.get 0
    i32.const 12
    i32.add
    global.set 0
    local.get 1
    i32.const 1
    i32.store
    local.get 1
    i32.const 4
    i32.add
    ;;> 5
    i32.const 5
    i32.store
    local.get 1
    i32.const 8
    i32.add
    ;;> Cons(-(5), Cons(-(1), Cons(0, Cons(10, Nil()))))
    global.get 0
    local.set 2
    global.get 0
    i32.const 12
    i32.add
    global.set 0
    local.get 2
    i32.const 1
    i32.store
    local.get 2
    i32.const 4
    i32.add
    ;;> -(5)
    i32.const 0
    ;;> 5
    i32.const 5
    i32.sub
    i32.store
    local.get 2
    i32.const 8
    i32.add
    ;;> Cons(-(1), Cons(0, Cons(10, Nil())))
    global.get 0
    local.set 3
    global.get 0
    i32.const 12
    i32.add
    global.set 0
    local.get 3
    i32.const 1
    i32.store
    local.get 3
    i32.const 4
    i32.add
    ;;> -(1)
    i32.const 0
    ;;> 1
    i32.const 1
    i32.sub
    i32.store
    local.get 3
    i32.const 8
    i32.add
    ;;> Cons(0, Cons(10, Nil()))
    global.get 0
    local.set 4
    global.get 0
    i32.const 12
    i32.add
    global.set 0
    local.get 4
    i32.const 1
    i32.store
    local.get 4
    i32.const 4
    i32.add
    ;;> 0
    i32.const 0
    i32.store
    local.get 4
    i32.const 8
    i32.add
    ;;> Cons(10, Nil())
    global.get 0
    local.set 5
    global.get 0
    i32.const 12
    i32.add
    global.set 0
    local.get 5
    i32.const 1
    i32.store
    local.get 5
    i32.const 4
    i32.add
    ;;> 10
    i32.const 10
    i32.store
    local.get 5
    i32.const 8
    i32.add
    ;;> Nil()
    global.get 0
    local.set 6
    global.get 0
    i32.const 4
    i32.add
    global.set 0
    local.get 6
    i32.const 0
    i32.store
    local.get 6
    i32.store
    local.get 5
    i32.store
    local.get 4
    i32.store
    local.get 3
    i32.store
    local.get 2
    i32.store
    local.get 1
    local.set 0
    ;;> (
    ;;|   printInt(sum(l));
    ;;|   printString(toString(mergeSort(l)))
    ;;| )
    ;;> l
    local.get 0
    call $L_sum
    call $Std_printInt
    drop
    ;;> l
    local.get 0
    call $L_mergeSort
    call $L_toString
    call $Std_printString
    drop
  )
)