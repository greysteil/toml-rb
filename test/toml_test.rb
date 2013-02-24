require_relative "helper"

class TomlTest < Test::Unit::TestCase
  def test_comment
    indentation_alternatives_for('# This is a comment').each do |str|
      match = Toml.parse(str, :root => :comment)
      assert_equal(' This is a comment', match.value)
    end
  end

  def test_keygroup
    indentation_alternatives_for('[akey]').each do |str|
      match = Toml.parse(str, :root => :keygroup)
      assert_equal('akey', match.value)
    end
  end

  def test_keyvalue_string
    indentation_alternatives_for('title = "TOML Example"').each do |str|
      match = Toml.parse(str, :root => :keyvalue)
      assert_equal('title', match.key)
      assert_equal('TOML Example', match.val)
      assert_equal({"title" => "TOML Example"}, match.value)
    end
  end

  def test_keyvalue_bool
    indentation_alternatives_for('enabled = true').each do |str|
      match = Toml.parse(str, :root => :keyvalue)
      assert_equal('enabled', match.key)
      assert_equal(true, match.val)
      assert_equal({"enabled" => true}, match.value)
    end
  end

  def test_keyvalue_integer
    indentation_alternatives_for('age = 26').each do |str|
      match = Toml.parse(str, :root => :keyvalue)
      assert_equal('age', match.key)
      assert_equal(26, match.val)
      assert_equal({"age" => 26}, match.value)
    end
  end

  def test_keyvalue_float
    indentation_alternatives_for('height = 1.69').each do |str|
      match = Toml.parse(str, :root => :keyvalue)
      assert_equal('height', match.key)
      assert_equal(1.69, match.val)
      assert_equal({"height" => 1.69}, match.value)
    end
  end

  def test_keyvalue_signed_numbers
    match = Toml.parse('age = +26', :root => :keyvalue)
    assert_equal(26, match.val)
    match = Toml.parse('age = -26', :root => :keyvalue)
    assert_equal(-26, match.val)
    match = Toml.parse('height = +1.69', :root => :keyvalue)
    assert_equal(1.69, match.val)
    match = Toml.parse('height = -1.69', :root => :keyvalue)
    assert_equal(-1.69, match.val)
  end

  def test_expressions_with_comments
    match = Toml.parse('[shouldwork] # with comment', :root => :keygroup)
    assert_equal('shouldwork', match.value)
    match = Toml.parse('works = true # with comment', :root => :keyvalue)
    assert_equal({"works" => true}, match.value)
  end

  private

  # Creates all the alternatives of valid indentations to test
  def indentation_alternatives_for(str)
    [str, "  #{str}", "\t#{str}", "\t\t#{str}"]
  end
end

