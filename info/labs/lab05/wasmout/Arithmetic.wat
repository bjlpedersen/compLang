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

  (func $Arithmetic_pow (param i32 i32) (result i32) (local i32)
    ;;> def pow(b: Int(32), e: Int(32)): Int(32) :=
    ;;|   (if((e == 0)) then
    ;;|     1
    ;;|   else
    ;;|     (if(((e % 2) == 0)) then
    ;;|       (
    ;;|         val rec: Int(32) =
    ;;|           pow(b, (e / 2));
    ;;|         (rec * rec)
    ;;|       )
    ;;|     else
    ;;|       (b * pow(b, (e - 1)))
    ;;|     end if)
    ;;|   end if)
    ;;| end pow
    ;;> e
    local.get 1
    ;;> 0
    i32.const 0
    i32.eq
    if (result i32)
      ;;> 1
      i32.const 1
    else
      ;;> e
      local.get 1
      ;;> 2
      i32.const 2
      i32.rem_s
      ;;> 0
      i32.const 0
      i32.eq
      if (result i32)
        ;;> (
        ;;|   val rec: Int(32) =
        ;;|     pow(b, (e / 2));
        ;;|   (rec * rec)
        ;;| )
        ;;> b
        local.get 0
        ;;> e
        local.get 1
        ;;> 2
        i32.const 2
        i32.div_s
        call $Arithmetic_pow
        local.set 2
        ;;> rec
        local.get 2
        ;;> rec
        local.get 2
        i32.mul
      else
        ;;> b
        local.get 0
        ;;> b
        local.get 0
        ;;> e
        local.get 1
        ;;> 1
        i32.const 1
        i32.sub
        call $Arithmetic_pow
        i32.mul
      end
    end
  )

  (func $Arithmetic_gcd (param i32 i32) (result i32) 
    ;;> def gcd(a: Int(32), b: Int(32)): Int(32) :=
    ;;|   (if(((a == 0) || (b == 0))) then
    ;;|     (a + b)
    ;;|   else
    ;;|     (if((a < b)) then
    ;;|       gcd(a, (b % a))
    ;;|     else
    ;;|       gcd((a % b), b)
    ;;|     end if)
    ;;|   end if)
    ;;| end gcd
    ;;> a
    local.get 0
    ;;> 0
    i32.const 0
    i32.eq
    if (result i32)
      i32.const 1
    else
      ;;> b
      local.get 1
      ;;> 0
      i32.const 0
      i32.eq
    end
    if (result i32)
      ;;> a
      local.get 0
      ;;> b
      local.get 1
      i32.add
    else
      ;;> a
      local.get 0
      ;;> b
      local.get 1
      i32.lt_s
      if (result i32)
        ;;> a
        local.get 0
        ;;> b
        local.get 1
        ;;> a
        local.get 0
        i32.rem_s
        call $Arithmetic_gcd
      else
        ;;> a
        local.get 0
        ;;> b
        local.get 1
        i32.rem_s
        ;;> b
        local.get 1
        call $Arithmetic_gcd
      end
    end
  )
  (export "_start" (func $Arithmetic_main))
  (func $Arithmetic_main 
    ;;> (
    ;;|   printInt(pow(0, 10));
    ;;|   printInt(pow(1, 5));
    ;;|   printInt(pow(2, 10));
    ;;|   printInt(pow(3, 3));
    ;;|   printInt(gcd(0, 10));
    ;;|   printInt(gcd(17, 99));
    ;;|   printInt(gcd(16, 46));
    ;;|   printInt(gcd(222, 888))
    ;;| )
    ;;> 0
    i32.const 0
    ;;> 10
    i32.const 10
    call $Arithmetic_pow
    call $Std_printInt
    drop
    ;;> (
    ;;|   printInt(pow(1, 5));
    ;;|   printInt(pow(2, 10));
    ;;|   printInt(pow(3, 3));
    ;;|   printInt(gcd(0, 10));
    ;;|   printInt(gcd(17, 99));
    ;;|   printInt(gcd(16, 46));
    ;;|   printInt(gcd(222, 888))
    ;;| )
    ;;> 1
    i32.const 1
    ;;> 5
    i32.const 5
    call $Arithmetic_pow
    call $Std_printInt
    drop
    ;;> (
    ;;|   printInt(pow(2, 10));
    ;;|   printInt(pow(3, 3));
    ;;|   printInt(gcd(0, 10));
    ;;|   printInt(gcd(17, 99));
    ;;|   printInt(gcd(16, 46));
    ;;|   printInt(gcd(222, 888))
    ;;| )
    ;;> 2
    i32.const 2
    ;;> 10
    i32.const 10
    call $Arithmetic_pow
    call $Std_printInt
    drop
    ;;> (
    ;;|   printInt(pow(3, 3));
    ;;|   printInt(gcd(0, 10));
    ;;|   printInt(gcd(17, 99));
    ;;|   printInt(gcd(16, 46));
    ;;|   printInt(gcd(222, 888))
    ;;| )
    ;;> 3
    i32.const 3
    ;;> 3
    i32.const 3
    call $Arithmetic_pow
    call $Std_printInt
    drop
    ;;> (
    ;;|   printInt(gcd(0, 10));
    ;;|   printInt(gcd(17, 99));
    ;;|   printInt(gcd(16, 46));
    ;;|   printInt(gcd(222, 888))
    ;;| )
    ;;> 0
    i32.const 0
    ;;> 10
    i32.const 10
    call $Arithmetic_gcd
    call $Std_printInt
    drop
    ;;> (
    ;;|   printInt(gcd(17, 99));
    ;;|   printInt(gcd(16, 46));
    ;;|   printInt(gcd(222, 888))
    ;;| )
    ;;> 17
    i32.const 17
    ;;> 99
    i32.const 99
    call $Arithmetic_gcd
    call $Std_printInt
    drop
    ;;> (
    ;;|   printInt(gcd(16, 46));
    ;;|   printInt(gcd(222, 888))
    ;;| )
    ;;> 16
    i32.const 16
    ;;> 46
    i32.const 46
    call $Arithmetic_gcd
    call $Std_printInt
    drop
    ;;> 222
    i32.const 222
    ;;> 888
    i32.const 888
    call $Arithmetic_gcd
    call $Std_printInt
    drop
  )
)