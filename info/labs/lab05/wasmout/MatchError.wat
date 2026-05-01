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
  (export "_start" (func $MatchError_main))
  (func $MatchError_main (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    ;;> Baz(Baz(Bar(1), Bar(2)), Baz(Bar(3), Bar(4))) match {
    ;;|   case Baz(Baz(_, Bar(_)), _) =>
    ;;|     ()
    ;;| }
    ;;> Baz(Baz(Bar(1), Bar(2)), Baz(Bar(3), Bar(4)))
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
    ;;> Baz(Bar(1), Bar(2))
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
    ;;> Bar(1)
    global.get 0
    local.set 3
    global.get 0
    i32.const 8
    i32.add
    global.set 0
    local.get 3
    i32.const 0
    i32.store
    local.get 3
    i32.const 4
    i32.add
    ;;> 1
    i32.const 1
    i32.store
    local.get 3
    i32.store
    local.get 2
    i32.const 8
    i32.add
    ;;> Bar(2)
    global.get 0
    local.set 4
    global.get 0
    i32.const 8
    i32.add
    global.set 0
    local.get 4
    i32.const 0
    i32.store
    local.get 4
    i32.const 4
    i32.add
    ;;> 2
    i32.const 2
    i32.store
    local.get 4
    i32.store
    local.get 2
    i32.store
    local.get 1
    i32.const 8
    i32.add
    ;;> Baz(Bar(3), Bar(4))
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
    ;;> Bar(3)
    global.get 0
    local.set 6
    global.get 0
    i32.const 8
    i32.add
    global.set 0
    local.get 6
    i32.const 0
    i32.store
    local.get 6
    i32.const 4
    i32.add
    ;;> 3
    i32.const 3
    i32.store
    local.get 6
    i32.store
    local.get 5
    i32.const 8
    i32.add
    ;;> Bar(4)
    global.get 0
    local.set 7
    global.get 0
    i32.const 8
    i32.add
    global.set 0
    local.get 7
    i32.const 0
    i32.store
    local.get 7
    i32.const 4
    i32.add
    ;;> 4
    i32.const 4
    i32.store
    local.get 7
    i32.store
    local.get 5
    i32.store
    local.get 1
    local.set 0
    local.get 0
    ;;> Baz(Baz(_, Bar(_)), _)
    local.set 8
    local.get 8
    i32.load
    i32.const 1
    i32.eq
    local.get 8
    ;;> adtField index: 0
    i32.const 4
    i32.add
    i32.load
    ;;> Baz(_, Bar(_))
    local.set 9
    local.get 9
    i32.load
    i32.const 1
    i32.eq
    local.get 9
    ;;> adtField index: 0
    i32.const 4
    i32.add
    i32.load
    ;;> _
    drop
    i32.const 1
    i32.and
    local.get 9
    ;;> adtField index: 1
    i32.const 8
    i32.add
    i32.load
    ;;> Bar(_)
    local.set 10
    local.get 10
    i32.load
    i32.const 0
    i32.eq
    local.get 10
    ;;> adtField index: 0
    i32.const 4
    i32.add
    i32.load
    ;;> _
    drop
    i32.const 1
    i32.and
    i32.and
    i32.and
    local.get 8
    ;;> adtField index: 1
    i32.const 8
    i32.add
    i32.load
    ;;> _
    drop
    i32.const 1
    i32.and
    if (result i32)
      ;;> ()
      i32.const 0
    else
      unreachable
    end
    drop
  )
)