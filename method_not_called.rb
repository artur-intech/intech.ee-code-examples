require "minitest/autorun"

class Report
  def html; end
end

class YamlFileReport
  def html
    read_large_file
    create_html_and_return_it
  end
end

class CachedReport
  def initialize(origin)
    @origin = origin
    @cache = []
  end

  def html
    @cache << @origin.html if @cache.empty?
    @cache.first
  end
end

class CachedReportTest < Minitest::Test
  def test_caches_call_to_origin_using_instance_variable_get
    cached = CachedReport.new(fake_origin)
    2.times { cached.html }

    # Deliberately breaking encapsulation.
    assert_equal 1, cached.instance_variable_get(:@cache).size
  end

  private

  def fake_origin
    origin = Object.new
    def origin.html = "any"
    origin
  end
end

class CachedReportTest < Minitest::Test
  def test_caches_call_to_origin_using_spy
    counter = CacheHitCounter.new

    cached = CachedReport.new(counter)
    2.times { cached.html }

    assert_equal 1, counter.count
  end
end

class CacheHitCounter
  attr_reader :count

  def initialize
    @count = 0
  end

  def html
    @count = @count.next
  end
end

module ReportInterfaceTest
  def test_implements_fixture_set_interface
    assert_respond_to @object, :html
  end
end

class YamlFileReportTest < Minitest::Test
  include ReportInterfaceTest

  def setup
    @object = YamlFileReport.new
  end
end

class CacheHitCounterTest < Minitest::Test
  include ReportInterfaceTest

  def setup
    @object = CacheHitCounter.new
  end
end
