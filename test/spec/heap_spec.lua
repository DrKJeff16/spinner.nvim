local heap = require("spinner.heap")
local t = require("t")
local eq = t.eq

describe("spinner.heap", function()
  it("push and peek returns the smallest element", function()
    local h = heap.new(function(a, b)
      return a < b
    end)
    h:push(5)
    h:push(2)
    h:push(9)

    eq(2, h:peek())
  end)

  it("pop returns elements in sorted order", function()
    local h = heap.new(function(a, b)
      return a < b
    end)

    local values = { 5, 3, 8, 1, 4 }
    for _, v in ipairs(values) do
      h:push(v)
    end

    local result = {}
    while not h:is_empty() do
      table.insert(result, h:pop())
    end

    eq({ 1, 3, 4, 5, 8 }, result)
  end)

  it("peek returns nil on empty h", function()
    local h = heap.new(function(a, b)
      return a < b
    end)
    eq(nil, h:peek())
  end)

  it("pop returns nil on empty h", function()
    local h = heap.new(function(a, b)
      return a < b
    end)
    eq(nil, h:pop())
  end)

  it("is_empty works correctly", function()
    local h = heap.new(function(a, b)
      return a < b
    end)
    eq(true, h:is_empty())
    h:push(1)
    eq(false, h:is_empty())
    h:pop()
    eq(true, h:is_empty())
  end)

  it("clear resets the h", function()
    local h = heap.new(function(a, b)
      return a < b
    end)
    h:push(1)
    h:push(2)
    h:clear()
    eq(true, h:is_empty())
    eq(nil, h:peek())
  end)

  it("supports tables as generic values", function()
    ---@type spinner.Heap<{ at: number }>
    local h = heap.new(function(a, b)
      return a.at < b.at
    end)
    h:push({ at = 5 })
    h:push({ at = 2 })
    h:push({ at = 8 })

    eq(2, h:peek().at)

    local first = h:pop()
    assert(first)
    eq(2, first.at)

    local second = h:pop()
    assert(second)
    eq(5, second.at)
  end)

  it("maintains h property after multiple pushes and pops", function()
    ---@type spinner.Heap<number>
    local h = heap.new(function(a, b)
      return a < b
    end)
    local values = { 10, 4, 6, 2, 8, 1, 9, 3, 7, 5 }
    for _, v in ipairs(values) do
      h:push(v)
    end

    local last = -math.huge
    while not h:is_empty() do
      local v = h:pop()
      assert(v)
      eq(true, v >= last)
      last = v
    end
  end)

  it("handles duplicate values correctly", function()
    local h = heap.new(function(a, b)
      return a < b
    end)
    h:push(5)
    h:push(5)
    h:push(5)

    eq(5, h:pop())
    eq(5, h:pop())
    eq(5, h:pop())
    eq(nil, h:pop())
  end)

  it("handles edge cases with clear and peek", function()
    local h = heap.new(function(a, b)
      return a < b
    end)
    h:push(1)
    h:push(2)
    h:clear()

    eq(true, h:is_empty())
    eq(nil, h:peek())
    eq(nil, h:pop())
  end)
end)
