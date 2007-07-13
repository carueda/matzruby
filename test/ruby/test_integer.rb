require 'test/unit'

class TestInteger < Test::Unit::TestCase
  VS = [
    -0x10000000000000001,
    -0x10000000000000000,
    -0xffffffffffffffff,
    -0x4000000000000001,
    -0x4000000000000000,
    -0x3fffffffffffffff,
    -0x100000001,
    -0x100000000,
    -0xffffffff,
    -0xc717a08d,
    -0x524b2245,
    -0x40000001,
    -0x40000000,
    -0x3fffffff,
    -0x8101,
    -0x7f01,
    -65,
    -64,
    -63,
    -62,
    -33,
    -32,
    -31,
    -30,
    -3,
    -2,
    -1,
    0,
    1,
    2,
    3,
    30,
    31,
    32,
    33,
    62,
    63,
    64,
    65,
    0x7f01,
    0x8101,
    0x3ffffffe,
    0x3fffffff,
    0x40000000,
    0x524b2245,
    0xc717a08d,
    0xffffffff,
    0x100000000,
    0x100000001,
    0x3ffffffffffffffe,
    0x3fffffffffffffff,
    0x4000000000000000,
    0xfffffffffffffffe,
    0xffffffffffffffff,
    0x10000000000000000,
  ]

  def test_plus
    VS.each {|a|
      VS.each {|b|
        c = a + b
        assert_equal(a, c - b, "(#{a} + #{b}) - #{b}")
        assert_equal(b, c - a, "(#{a} + #{b}) - #{a}")
      }
    }
  end

  def test_minus
    VS.each {|a|
      VS.each {|b|
        c = a - b
        assert_equal(a, c + b, "(#{a} - #{b}) + #{b}")
        assert_equal(-b, c - a, "(#{a} - #{b}) - #{a}")
      }
    }
  end

  def test_mult
    VS.each {|a|
      VS.each {|b|
        c = a * b
        assert_equal(a, c / b, "(#{a} * #{b}) / #{b}") if b != 0
        assert_equal(b, c / a, "(#{a} * #{b}) / #{a}") if a != 0
        assert_equal(a.abs * b.abs, (a * b).abs, "(#{a} * #{b}).abs")
      }
    }
  end

  def test_divmod
    VS.each {|a|
      VS.each {|b|
        next if b == 0
        q, r = a.divmod(b)
        assert_equal(a, b*q+r)
        assert(r.abs < b.abs)
        assert(0 < b ? (0 <= r && r < b) : (b < r && r <= 0))
        assert_equal(q, a/b)
        assert_equal(q, a.div(b))
        assert_equal(r, a%b)
        assert_equal(r, a.modulo(b))
      }
    }
  end

  def test_pow
    small_values = VS.find_all {|v| 0 < v && v < 1000 }
    VS.each {|a|
      small_values.each {|b|
        c = a ** b
        d = 1
        b.times { d *= a }
        assert_equal(d, c, "(#{a}) ** #{b}")
      }
    }
  end

  def test_not
    VS.each {|a|
      b = ~a
      assert_equal(0, a & b, "#{a} & ~#{a}")
      assert_equal(-1, a | b, "#{a} | ~#{a}")
    }
  end

  def test_or
    VS.each {|a|
      VS.each {|b|
        c = a | b
        assert_equal(-1, c | ~a, "(#{a} | #{b}) | ~#{a})")
        assert_equal(-1, c | ~b, "(#{a} | #{b}) | ~#{b})")
      }
    }
  end

  def test_and
    VS.each {|a|
      VS.each {|b|
        c = a & b
        assert_equal(0, c & ~a, "(#{a} & #{b}) & ~#{a}")
        assert_equal(0, c & ~b, "(#{a} & #{b}) & ~#{b}")
      }
    }
  end

  def test_xor
    VS.each {|a|
      VS.each {|b|
        c = a ^ b
        assert_equal(b, c ^ a, "(#{a} ^ #{b}) ^ #{a}")
        assert_equal(a, c ^ b, "(#{a} ^ #{b}) ^ #{b}")
      }
    }
  end

  def test_lshift
    small_values = VS.find_all {|v| -1000 < v && v < 1000 }
    VS.each {|a|
      small_values.each {|b|
        c = a << b
        if 0 <= b
          assert_equal(a, c >> b, "(#{a} << #{b}) >> #{b}")
          assert_equal(a * 2**b, c, "#{a} << #{b}")
        else
          assert_equal(a / 2**(-b), c, "#{a} << #{b}")
        end
      }
    }
  end

  def test_rshift
    small_values = VS.find_all {|v| -1000 < v && v < 1000 }
    VS.each {|a|
      small_values.each {|b|
        c = a >> b
        if 0 < b
          assert_equal(a / 2**b, c, "#{a} >> #{b}")
        else
          assert_equal(a, c << b, "(#{a} >> #{b}) << #{b}")
          assert_equal(a * 2**(-b), c, "#{a} >> #{b}")
        end
      }
    }
  end

  def test_succ
    VS.each {|a|
      b = a.succ
      assert_equal(a+1, b, "(#{a}).succ")
      assert_equal(a, b.pred, "(#{a}).succ.pred")
    }
  end

  def test_pred
    VS.each {|a|
      b = a.pred
      assert_equal(a-1, b, "(#{a}).pred")
      assert_equal(a, b.succ, "(#{a}).pred.succ")
    }
  end

  def test_unary_plus
    VS.each {|a|
      b = +a
      assert_equal(a, b, "+(#{a})")
    }
  end

  def test_unary_minus
    VS.each {|a|
      b = -a
      assert_equal(0-a, b, "-(#{a})")
    }
  end

  def test_eq
    VS.each_with_index {|a, i|
      VS.each_with_index {|b, j|
        c = a == b
        assert_equal(i == j, c, "#{a} == #{b}")
      }
    }
  end

  def test_abs
    VS.each {|a|
      b = a.abs
      if a < 0
        assert_equal(-a, b, "(#{a}).abs")
      else
        assert_equal(a, b, "(#{a}).abs")
      end
    }
  end

  def test_ceil
    VS.each {|a|
      assert_equal(a, a.ceil, "(#{a}).ceil")
    }
  end

  def test_floor
    VS.each {|a|
      assert_equal(a, a.floor, "(#{a}).floor")
    }
  end

  def test_round
    VS.each {|a|
      assert_equal(a, a.round, "(#{a}).round")
    }
  end

  def test_truncate
    VS.each {|a|
      assert_equal(a, a.truncate, "(#{a}).truncate")
    }
  end

  def test_remainder
    VS.each {|a|
      VS.each {|b|
        next if b == 0
        r = a.remainder(b)
        if a < 0
          assert_operator(-b.abs, :<, r, "#{a}.remainder(#{b})")
          assert_operator(r, :<=, 0, "#{a}.remainder(#{b})")
        elsif 0 < a
          assert_operator(0, :<=, r, "#{a}.remainder(#{b})")
          assert_operator(r, :<, b.abs, "#{a}.remainder(#{b})")
        else
          assert_equal(0, r, "#{a}.remainder(#{b})")
        end
      }
    }
  end

  def test_nonzero?
    VS.each {|a|
      b = a.nonzero?
      if a == 0
        assert_equal(nil, b, "(#{a}).nonzero?")
      else
        assert_equal(a, b, "(#{a}).nonzero?")
      end
    }
  end

  def test_zero?
    VS.each {|a|
      b = a.zero?
      if a == 0
        assert_equal(true, b, "(#{a}).zero?")
      else
        assert_equal(false, b, "(#{a}).zero?")
      end
    }
  end
end
