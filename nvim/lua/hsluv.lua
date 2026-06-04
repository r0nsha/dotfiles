-- Taken and slightly modified without shame from https://github.com/hsluv/hsluv-lua/blob/master/hsluv.lua

--[[
Lua implementation of HSLuv and HPLuv color spaces
Homepage: http://www.hsluv.org/

Copyright (C) 2019 Alexei Boronine

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

---@class hsluv.Line
---@field slope number
---@field intercept number

local M = {}

local hexChars = "0123456789abcdef"

---@param line hsluv.Line
---@return number
local function distance_line_from_origin(line)
  return math.abs(line.intercept) / math.sqrt((line.slope ^ 2) + 1)
end

---@param theta number
---@param line hsluv.Line
---@return number
local function length_of_ray_until_intersect(theta, line)
  return line.intercept / (math.sin(theta) - line.slope * math.cos(theta))
end

---@param l number
---@return hsluv.Line[]
function M.get_bounds(l)
  local result = {}
  local sub2
  local sub1 = ((l + 16) ^ 3) / 1560896
  if sub1 > M.epsilon then
    sub2 = sub1
  else
    sub2 = l / M.kappa
  end

  for i = 1, 3 do
    local m1 = M.m[i][1]
    local m2 = M.m[i][2]
    local m3 = M.m[i][3]

    for t = 0, 1 do
      local top1 = (284517 * m1 - 94839 * m3) * sub2
      local top2 = (838422 * m3 + 769860 * m2 + 731718 * m1) * l * sub2 - 769860 * t * l
      local bottom = (632260 * m3 - 126452 * m2) * sub2 + 126452 * t
      table.insert(result, {
        slope = top1 / bottom,
        intercept = top2 / bottom,
      })
    end
  end
  return result
end

---@param l number
---@return number
function M.max_safe_chroma_for_l(l)
  local bounds = M.get_bounds(l)
  local min = 1.7976931348623157e+308

  for i = 1, 6 do
    local length = distance_line_from_origin(bounds[i])
    if length >= 0 then min = math.min(min, length) end
  end
  return min
end

---@param l number
---@param h number
---@return number
function M.max_safe_chroma_for_lh(l, h)
  local hrad = h / 360 * math.pi * 2
  local bounds = M.get_bounds(l)
  local min = 1.7976931348623157e+308

  for i = 1, 6 do
    local bound = bounds[i]
    local length = length_of_ray_until_intersect(hrad, bound)
    if length >= 0 then min = math.min(min, length) end
  end
  return min
end

---@param a number[]
---@param b number[]
---@return number
function M.dot_product(a, b)
  local sum = 0
  for i = 1, 3 do
    sum = sum + a[i] * b[i]
  end
  return sum
end

---@param c number
---@return number
function M.from_linear(c)
  if c <= 0.0031308 then
    return 12.92 * c
  else
    return 1.055 * (c ^ 0.416666666666666685) - 0.055
  end
end

---@param c number
---@return number
function M.to_linear(c)
  if c > 0.04045 then
    return ((c + 0.055) / 1.055) ^ 2.4
  else
    return c / 12.92
  end
end

---@param tuple number[]
---@return number[]
function M.xyz_to_rgb(tuple)
  return {
    M.from_linear(M.dot_product(M.m[1], tuple)),
    M.from_linear(M.dot_product(M.m[2], tuple)),
    M.from_linear(M.dot_product(M.m[3], tuple)),
  }
end

---@param tuple number[]
---@return number[]
function M.rgb_to_xyz(tuple)
  local rgbl = {
    M.to_linear(tuple[1]),
    M.to_linear(tuple[2]),
    M.to_linear(tuple[3]),
  }
  return {
    M.dot_product(M.minv[1], rgbl),
    M.dot_product(M.minv[2], rgbl),
    M.dot_product(M.minv[3], rgbl),
  }
end

---@param Y number
---@return number
function M.y_to_l(Y)
  if Y <= M.epsilon then
    return Y / M.refY * M.kappa
  else
    return 116 * ((Y / M.refY) ^ 0.333333333333333315) - 16
  end
end

---@param L number
---@return number
function M.l_to_y(L)
  if L <= 8 then
    return M.refY * L / M.kappa
  else
    return M.refY * (((L + 16) / 116) ^ 3)
  end
end

---@param tuple number[]
---@return number[]
function M.xyz_to_luv(tuple)
  local X = tuple[1]
  local Y = tuple[2]
  local divider = X + 15 * Y + 3 * tuple[3]
  local varU = 4 * X
  local varV = 9 * Y
  if divider ~= 0 then
    varU = varU / divider
    varV = varV / divider
  else
    varU = 0
    varV = 0
  end
  local L = M.y_to_l(Y)
  if L == 0 then return { 0, 0, 0 } end
  return { L, 13 * L * (varU - M.refU), 13 * L * (varV - M.refV) }
end

---@param tuple number[]
---@return number[]
function M.luv_to_xyz(tuple)
  local L = tuple[1]
  local U = tuple[2]
  local V = tuple[3]
  if L == 0 then return { 0, 0, 0 } end
  local varU = U / (13 * L) + M.refU
  local varV = V / (13 * L) + M.refV
  local Y = M.l_to_y(L)
  local X = 0 - (9 * Y * varU) / (((varU - 4) * varV) - varU * varV)
  return { X, Y, (9 * Y - 15 * varV * Y - varV * X) / (3 * varV) }
end

---@param tuple number[]
---@return number[]
function M.luv_to_lch(tuple)
  local L = tuple[1]
  local U = tuple[2]
  local V = tuple[3]
  local C = math.sqrt(U * U + V * V)
  local H
  if C < 0.00000001 then
    H = 0
  else
    H = math.atan2(V, U) * 180.0 / 3.1415926535897932
    if H < 0 then H = 360 + H end
  end
  return { L, C, H }
end

---@param tuple number[]
---@return number[]
function M.lch_to_luv(tuple)
  local L = tuple[1]
  local C = tuple[2]
  local Hrad = tuple[3] / 360.0 * 2 * math.pi
  return { L, math.cos(Hrad) * C, math.sin(Hrad) * C }
end

---@param tuple number[]
---@return number[]
function M.hsluv_to_lch(tuple)
  local H = tuple[1]
  local S = tuple[2]
  local L = tuple[3]
  if L > 99.9999999 then return { 100, 0, H } end
  if L < 0.00000001 then return { 0, 0, H } end
  return { L, M.max_safe_chroma_for_lh(L, H) / 100 * S, H }
end

---@param tuple number[]
---@return number[]
function M.lch_to_hsluv(tuple)
  local L = tuple[1]
  local C = tuple[2]
  local H = tuple[3]
  local max_chroma = M.max_safe_chroma_for_lh(L, H)
  if L > 99.9999999 then return { H, 0, 100 } end
  if L < 0.00000001 then return { H, 0, 0 } end

  return { H, C / max_chroma * 100, L }
end

---@param tuple number[]
---@return number[]
function M.hpluv_to_lch(tuple)
  local H = tuple[1]
  local S = tuple[2]
  local L = tuple[3]
  if L > 99.9999999 then return { 100, 0, H } end
  if L < 0.00000001 then return { 0, 0, H } end
  return { L, M.max_safe_chroma_for_l(L) / 100 * S, H }
end

---@param tuple number[]
---@return number[]
function M.lch_to_hpluv(tuple)
  local L = tuple[1]
  local C = tuple[2]
  local H = tuple[3]
  if L > 99.9999999 then return { H, 0, 100 } end
  if L < 0.00000001 then return { H, 0, 0 } end
  return { H, C / M.max_safe_chroma_for_l(L) * 100, L }
end

---@param tuple number[]
---@return string
function M.rgb_to_hex(tuple)
  local h = "#"
  for i = 1, 3 do
    local c = math.floor(tuple[i] * 255 + 0.5)
    local digit2 = math.fmod(c, 16)
    local x = (c - digit2) / 16
    local digit1 = math.floor(x)
    h = h .. string.sub(hexChars, digit1 + 1, digit1 + 1)
    h = h .. string.sub(hexChars, digit2 + 1, digit2 + 1)
  end
  return h
end

---@param hex string
---@return number[]
function M.hex_to_rgb(hex)
  hex = string.lower(hex)
  local ret = {}
  for i = 0, 2 do
    local char1 = string.sub(hex, i * 2 + 2, i * 2 + 2)
    local char2 = string.sub(hex, i * 2 + 3, i * 2 + 3)
    local digit1 = string.find(hexChars, char1) - 1
    local digit2 = string.find(hexChars, char2) - 1
    ret[i + 1] = (digit1 * 16 + digit2) / 255.0
  end
  return ret
end

---@param tuple number[]
---@return number[]
function M.lch_to_rgb(tuple) return M.xyz_to_rgb(M.luv_to_xyz(M.lch_to_luv(tuple))) end

---@param tuple number[]
---@return number[]
function M.rgb_to_lch(tuple) return M.luv_to_lch(M.xyz_to_luv(M.rgb_to_xyz(tuple))) end

---@param tuple number[]
---@return number[]
function M.hsluv_to_rgb(tuple) return M.lch_to_rgb(M.hsluv_to_lch(tuple)) end

---@param tuple number[]
---@return number[]
function M.rgb_to_hsluv(tuple) return M.lch_to_hsluv(M.rgb_to_lch(tuple)) end

---@param tuple number[]
---@return number[]
function M.hpluv_to_rgb(tuple) return M.lch_to_rgb(M.hpluv_to_lch(tuple)) end

---@param tuple number[]
---@return number[]
function M.rgb_to_hpluv(tuple) return M.lch_to_hpluv(M.rgb_to_lch(tuple)) end

---@param tuple number[]
---@return string
function M.hsluv_to_hex(tuple) return M.rgb_to_hex(M.hsluv_to_rgb(tuple)) end

---@param tuple number[]
---@return string
function M.hpluv_to_hex(tuple) return M.rgb_to_hex(M.hpluv_to_rgb(tuple)) end

---@param s string
---@return number[]
function M.hex_to_hsluv(s) return M.rgb_to_hsluv(M.hex_to_rgb(s)) end

---@param s string
---@return number[]
function M.hex_to_hpluv(s) return M.rgb_to_hpluv(M.hex_to_rgb(s)) end

---@type table<number, table<number, number>>
M.m = {
  { 3.240969941904521, -1.537383177570093, -0.498610760293 },
  { -0.96924363628087, 1.87596750150772, 0.041555057407175 },
  { 0.055630079696993, -0.20397695888897, 1.056971514242878 },
}

---@type table<number, table<number, number>>
M.minv = {
  { 0.41239079926595, 0.35758433938387, 0.18048078840183 },
  { 0.21263900587151, 0.71516867876775, 0.072192315360733 },
  { 0.019330818715591, 0.11919477979462, 0.95053215224966 },
}

M.refY = 1.0
M.refU = 0.19783000664283
M.refV = 0.46831999493879
M.kappa = 903.2962962
M.epsilon = 0.0088564516

return M
