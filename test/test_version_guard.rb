require 'minitest/autorun'
require 'minitest/pride'
require 'version_guard'

class TestVersionGuard < MiniTest::Unit::TestCase
  VERSION = '1.2.3'

  def test_true
    assert_equal true, VersionGuard.check('1', '1')
    assert_equal true, VersionGuard.check('1', '= 1')
    assert_equal true, VersionGuard.check('1', '>= 1')
    assert_equal true, VersionGuard.check('1', '~> 1')
    assert_equal true, VersionGuard.check('2', '> 1')
    assert_equal true, VersionGuard.check('1.0', '>= 1.0')
    assert_equal true, VersionGuard.check('1.0.0', '>= 0')
    assert_equal true, VersionGuard.check('1.0.1', '~> 1.0.0')
    assert_equal true, VersionGuard.check('1.0.0', '< 2.0.0')
    assert_equal true, VersionGuard.check('1.0.0', ['> 0.9.0', '< 1.1.0'])
  end

  def test_false
    assert_equal false, VersionGuard.check('1', '2')
    assert_equal false, VersionGuard.check('1', '= 2')
    assert_equal false, VersionGuard.check('1', '>= 2')
    assert_equal false, VersionGuard.check('1', '~> 2')
    assert_equal false, VersionGuard.check('2', '> 2')
    assert_equal false, VersionGuard.check('1.0', '>= 1.1')
    assert_equal false, VersionGuard.check('1.0.0', '>= 1.0.1')
    assert_equal false, VersionGuard.check('1.0.1', '~> 1.1')
    assert_equal false, VersionGuard.check('1.0.0', '> 2.0.0')
    assert_equal false, VersionGuard.check('1.0.0', ['> 1.0.1', '< 1.1.0'])
  end

  def test_constants
    assert_equal true, VersionGuard.check('TestVersionGuard::VERSION', '> 1.0.0')
    assert_equal false, VersionGuard.check('TestVersionGuard::VERSION', '> 2.0.0')
    assert_raises(NameError) { VersionGuard.check('a', '> 1.0.0') }
  end

  def test_nil
    assert_raises(VersionGuard::Error) { VersionGuard.check(nil, '1') }
    assert_raises(VersionGuard::Error) { VersionGuard.check('1', nil) }
    assert_raises(VersionGuard::Error) { VersionGuard.check(nil, nil) }
  end

  def test_empty_string
    assert_raises(VersionGuard::Error) { VersionGuard.check('', '') }
    assert_raises(VersionGuard::Error) { VersionGuard.check('', '1') }
    assert_raises(VersionGuard::Error) { VersionGuard.check('1', '') }
  end
end
