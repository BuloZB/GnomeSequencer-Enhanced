-- For All Indents And Purposes
local revision = 17
-- Maintainer: kristofer.karlsson@gmail.com

-- For All Indents And Purposes -
-- a indentation + syntax highlighting library
-- All valid lua code should be processed correctly.

-- Usage (for developers)
--------
-- Variant 1: - non embedded
-- 1) Add ForAllIndentsAndPurposes to your dependencies (or optional dependencies)

-- Variant 2: - embedded
-- 1.a) Copy indent.lua to your addon directory
-- 1.b) Put indent.lua first in your list of files in the TOC

-- For both variants:
-- 2) hook the editboxes that you want to have indentation like this:
-- IndentationLib.enable(editbox [, colorTable [, tabWidth] ])
-- if you don't select a color table, it will use the default.
-- Read through this code for further usage help.
-- (The documentation IS the code)

if not IndentationLib then
  IndentationLib = {}
end

if not IndentationLib.revision or revision > IndentationLib.revision then
  local lib = IndentationLib
  lib.revision = revision

  local stringlen = string.len
  local stringformat = string.format
  local stringfind = string.find
  local stringsub = string.sub
  local stringbyte = string.byte
  local stringchar = string.char
  local stringrep = string.rep
  local stringgsub = string.gsub

  local workingTable = {}
  local workingTable2 = {}
  local function tableclear(t)
  for k in next,t do
    t[k] = nil
  end
end

local function stringinsert(s, pos, insertStr)
  return stringsub(s, 1, pos) .. insertStr .. stringsub(s, pos + 1)
end
lib.stringinsert = stringinsert

local function stringdelete(s, pos1, pos2)
  return stringsub(s, 1, pos1 - 1) .. stringsub(s, pos2 + 1)
end
lib.stringdelete = stringdelete

-- token types
local tokens = {}
lib.Tokens = tokens

tokens.UNKNOWN = 0
tokens.NUMBER = 1
tokens.LINEBREAK = 2
tokens.WHITESPACE = 3
tokens.IDENTIFIER = 4
tokens.ASSIGNMENT = 5
tokens.EQUALITY = 6
tokens.MINUS = 7
tokens.COMMENT_SHORT = 8
tokens.COMMENT_LONG = 9
tokens.STRING = 10
tokens.LEFTBRACKET = 11
tokens.PERIOD = 12
tokens.DOUBLEPERIOD = 13
tokens.TRIPLEPERIOD = 14
tokens.LTE = 15
tokens.LT = 16
tokens.GTE = 17
tokens.GT = 18
tokens.NOTEQUAL = 19
tokens.COMMA = 20
tokens.SEMICOLON = 21
tokens.COLON = 22
tokens.LEFTPAREN = 23
tokens.RIGHTPAREN = 24
tokens.PLUS = 25
tokens.SLASH = 27
tokens.LEFTWING = 28
tokens.RIGHTWING = 29
tokens.CIRCUMFLEX = 30
tokens.ASTERISK = 31
tokens.RIGHTBRACKET = 32
tokens.KEYWORD = 33
tokens.SPECIAL = 34
tokens.VERTICAL = 35
tokens.TILDE = 36

-- WoW specific tokens
tokens.COLORCODE_START = 37
tokens.COLORCODE_STOP = 38

-- new as of lua 5.1
tokens.HASH = 39
tokens.PERCENT = 40


-- ascii codes
local bytes = {}
lib.bytes = bytes
bytes.BYTE_LINEBREAK_UNIX = stringbyte("\n")
bytes.BYTE_LINEBREAK_MAC = stringbyte("\r")
bytes.BYTE_SINGLE_QUOTE = stringbyte("'")
bytes.BYTE_DOUBLE_QUOTE = stringbyte('"')
bytes.BYTE_0 = stringbyte("0")
bytes.BYTE_9 = stringbyte("9")
bytes.BYTE_PERIOD = stringbyte(".")
bytes.BYTE_SPACE = stringbyte(" ")
bytes.BYTE_TAB = stringbyte("\t")
bytes.BYTE_E = stringbyte("E")
bytes.BYTE_e = stringbyte("e")
bytes.BYTE_MINUS = stringbyte("-")
bytes.BYTE_EQUALS = stringbyte("=")
bytes.BYTE_LEFTBRACKET = stringbyte("[")
bytes.BYTE_RIGHTBRACKET = stringbyte("]")
bytes.BYTE_BACKSLASH = stringbyte("\\")
bytes.BYTE_COMMA = stringbyte(",")
bytes.BYTE_SEMICOLON = stringbyte(";")
bytes.BYTE_COLON = stringbyte(":")
bytes.BYTE_LEFTPAREN = stringbyte("(")
bytes.BYTE_RIGHTPAREN = stringbyte(")")
bytes.BYTE_TILDE = stringbyte("~")
bytes.BYTE_PLUS = stringbyte("+")
bytes.BYTE_SLASH = stringbyte("/")
bytes.BYTE_LEFTWING = stringbyte("{")
bytes.BYTE_RIGHTWING = stringbyte("}")
bytes.BYTE_CIRCUMFLEX = stringbyte("^")
bytes.BYTE_ASTERISK = stringbyte("*")
bytes.BYTE_LESSTHAN = stringbyte("<")
bytes.BYTE_GREATERTHAN = stringbyte(">")
-- WoW specific chars
bytes.BYTE_VERTICAL = stringbyte("|")
bytes.BYTE_r = stringbyte("r")
bytes.BYTE_c = stringbyte("c")

-- new as of lua 5.1
bytes.BYTE_HASH = stringbyte("#")
bytes.BYTE_PERCENT = stringbyte("%")


local linebreakCharacters = {}
lib.linebreakCharacters = linebreakCharacters
linebreakCharacters[bytes.BYTE_LINEBREAK_UNIX] = 1
linebreakCharacters[bytes.BYTE_LINEBREAK_MAC] = 1

local whitespaceCharacters = {}
lib.whitespaceCharacters = whitespaceCharacters
whitespaceCharacters[bytes.BYTE_SPACE] = 1
whitespaceCharacters[bytes.BYTE_TAB] = 1

local specialCharacters = {}
lib.specialCharacters = specialCharacters
specialCharacters[bytes.BYTE_PERIOD] = -1
specialCharacters[bytes.BYTE_LESSTHAN] = -1
specialCharacters[bytes.BYTE_GREATERTHAN] = -1
specialCharacters[bytes.BYTE_LEFTBRACKET] = -1
specialCharacters[bytes.BYTE_EQUALS] = -1
specialCharacters[bytes.BYTE_MINUS] = -1
specialCharacters[bytes.BYTE_SINGLE_QUOTE] = -1
specialCharacters[bytes.BYTE_DOUBLE_QUOTE] = -1
specialCharacters[bytes.BYTE_TILDE] = -1
specialCharacters[bytes.BYTE_RIGHTBRACKET] = tokens.RIGHTBRACKET
specialCharacters[bytes.BYTE_COMMA] = tokens.COMMA
specialCharacters[bytes.BYTE_COLON] = tokens.COLON
specialCharacters[bytes.BYTE_SEMICOLON] = tokens.SEMICOLON
specialCharacters[bytes.BYTE_LEFTPAREN] = tokens.LEFTPAREN
specialCharacters[bytes.BYTE_RIGHTPAREN] = tokens.RIGHTPAREN
specialCharacters[bytes.BYTE_PLUS] = tokens.PLUS
specialCharacters[bytes.BYTE_SLASH] = tokens.SLASH
specialCharacters[bytes.BYTE_LEFTWING] = tokens.LEFTWING
specialCharacters[bytes.BYTE_RIGHTWING] = tokens.RIGHTWING
specialCharacters[bytes.BYTE_CIRCUMFLEX] = tokens.CIRCUMFLEX
specialCharacters[bytes.BYTE_ASTERISK] = tokens.ASTERISK
-- WoW specific
specialCharacters[bytes.BYTE_VERTICAL] = -1
-- new as of lua 5.1
specialCharacters[bytes.BYTE_HASH] = tokens.HASH
specialCharacters[bytes.BYTE_PERCENT] = tokens.PERCENT

local function nextNumberExponentPartInt(text, pos)
  while true do
    local byte = stringbyte(text, pos)
    if not byte then
      return tokens.NUMBER, pos
    end
    if byte >= bytes.BYTE_0 and byte <= bytes.BYTE_9 then
      pos = pos + 1
    else
      return tokens.NUMBER, pos
    end
  end
end

local function nextNumberExponentPart(text, pos)
  local byte = stringbyte(text, pos)
  if not byte then
    return tokens.NUMBER, pos
  end

  if byte == bytes.BYTE_MINUS then
    -- handle this case: a = 1.2e-- some comment
    -- i decide to let 1.2e be parsed as a a number
    byte = stringbyte(text, pos + 1)
    if byte == bytes.BYTE_MINUS then
      return tokens.NUMBER, pos
    end
    return nextNumberExponentPartInt(text, pos + 1)
  end
  return nextNumberExponentPartInt(text, pos)
end

local function nextNumberFractionPart(text, pos)
  while true do
    local byte = stringbyte(text, pos)
    if not byte then
      return tokens.NUMBER, pos
    end

    if byte >= bytes.BYTE_0 and byte <= bytes.BYTE_9 then
      pos = pos + 1
    elseif byte == bytes.BYTE_E or byte == bytes.BYTE_e then
      return nextNumberExponentPart(text, pos + 1)
    else
      return tokens.NUMBER, pos
    end
  end
end

local function nextNumberIntPart(text, pos)
  while true do
    local byte = stringbyte(text, pos)
    if not byte then
      return tokens.NUMBER, pos
    end

    if byte >= bytes.BYTE_0 and byte <= bytes.BYTE_9 then
      pos = pos + 1
    elseif byte == bytes.BYTE_PERIOD then
      return nextNumberFractionPart(text, pos + 1)
    elseif byte == bytes.BYTE_E or byte == bytes.BYTE_e then
      return nextNumberExponentPart(text, pos + 1)
    else
      return tokens.NUMBER, pos
    end
  end
end

local function nextIdentifier(text, pos)
  while true do
    local byte = stringbyte(text, pos)

    if not byte or linebreakCharacters[byte] or whitespaceCharacters[byte] or specialCharacters[byte] then
      return tokens.IDENTIFIER, pos
    end
    pos = pos + 1
  end
end

-- returns false or: true, nextPos, equalsCount
local function isBracketStringNext(text, pos)
  local byte = stringbyte(text, pos)
  if byte == bytes.BYTE_LEFTBRACKET then
    local pos2 = pos + 1
    byte = stringbyte(text, pos2)
    while byte == bytes.BYTE_EQUALS do
      pos2 = pos2 + 1
      byte = stringbyte(text, pos2)
    end
    if byte == bytes.BYTE_LEFTBRACKET then
      return true, pos2 + 1, (pos2 - 1) - pos
    else
      return false
    end
  else
    return false
  end
end

-- Already parsed the [==[ part when get here
local function nextBracketString(text, pos, equalsCount)
  local state = 0
  while true do
    local byte = stringbyte(text, pos)
    if not byte then
      return tokens.STRING, pos
    end

    if byte == bytes.BYTE_RIGHTBRACKET then
      if state == 0 then
        state = 1
      elseif state == equalsCount + 1 then
        return tokens.STRING, pos + 1
      else
        state = 0
      end
    elseif byte == bytes.BYTE_EQUALS then
      if state > 0 then
         state = state + 1
      end
    else
      state = 0
    end
    pos = pos + 1
  end
end

local function nextComment(text, pos)
  -- When we get here we have already parsed the "--"
  -- Check for long comment
  local isBracketString, nextPos, equalsCount = isBracketStringNext(text, pos)
  if isBracketString then
    local tokenType, nextPos2 = nextBracketString(text, nextPos, equalsCount)
    return tokens.COMMENT_LONG, nextPos2
  end

  local byte = stringbyte(text, pos)
  -- Short comment, find the first linebreak
  while true do
    byte = stringbyte(text, pos)
    if not byte then
      return tokens.COMMENT_SHORT, pos
    end
    if linebreakCharacters[byte] then
      return tokens.COMMENT_SHORT, pos
    end
    pos = pos + 1
  end
end

local function nextString(text, pos, character)
  local even = true
  while true do
    local byte = stringbyte(text, pos)
    if not byte then
      return tokens.STRING, pos
    end

    if byte == character then
      if even then
        return tokens.STRING, pos + 1
      end
    end
    if byte == bytes.BYTE_BACKSLASH then
      even = not even
    else
      even = true
    end

    pos = pos + 1
  end
end

-- INPUT
-- 1: text: text to search in
-- 2: tokenPos:  where to start searching
-- OUTPUT
-- 1: token type
-- 2: position after the last character of the token
function nextToken(text, pos)
  local byte = stringbyte(text, pos)
  if not byte then
   return nil
  end

  if linebreakCharacters[byte] then
    return tokens.LINEBREAK, pos + 1
  end

  if whitespaceCharacters[byte] then
    while true do
      pos = pos + 1
      byte = stringbyte(text, pos)
      if not byte or not whitespaceCharacters[byte] then
        return tokens.WHITESPACE, pos
      end
    end
  end

  local token = specialCharacters[byte]
  if token then
    if token ~= -1 then
      return token, pos + 1
    end

    -- WoW specific (for color codes)
    if byte == bytes.BYTE_VERTICAL then
      byte = stringbyte(text, pos + 1)
      if byte == bytes.BYTE_VERTICAL then
         return tokens.VERTICAL, pos + 2
      end
      if byte == bytes.BYTE_c then
         return tokens.COLORCODE_START, pos + 10
      end
      if byte == bytes.BYTE_r then
         return tokens.COLORCODE_STOP, pos + 2
      end
      return tokens.UNKNOWN, pos + 1
    end

    if byte == bytes.BYTE_MINUS then
      byte = stringbyte(text, pos + 1)
      if byte == bytes.BYTE_MINUS then
         return nextComment(text, pos + 2)
      end
      return tokens.MINUS, pos + 1
    end

    if byte == bytes.BYTE_SINGLE_QUOTE then
      return nextString(text, pos + 1, bytes.BYTE_SINGLE_QUOTE)
    end

    if byte == bytes.BYTE_DOUBLE_QUOTE then
      return nextString(text, pos + 1, bytes.BYTE_DOUBLE_QUOTE)
    end

    if byte == bytes.BYTE_LEFTBRACKET then
      local isBracketString, nextPos, equalsCount = isBracketStringNext(text, pos)
      if isBracketString then
         return nextBracketString(text, nextPos, equalsCount)
      else
         return tokens.LEFTBRACKET, pos + 1
      end
    end

    if byte == bytes.BYTE_EQUALS then
      byte = stringbyte(text, pos + 1)
      if not byte then
         return tokens.ASSIGNMENT, pos + 1
      end
      if byte == bytes.BYTE_EQUALS then
         return tokens.EQUALITY, pos + 2
      end
      return tokens.ASSIGNMENT, pos + 1
    end

    if byte == bytes.BYTE_PERIOD then
      byte = stringbyte(text, pos + 1)
      if not byte then
         return tokens.PERIOD, pos + 1
      end
      if byte == bytes.BYTE_PERIOD then
         byte = stringbyte(text, pos + 2)
         if byte == bytes.BYTE_PERIOD then
      return tokens.TRIPLEPERIOD, pos + 3
         end
         return tokens.DOUBLEPERIOD, pos + 2
      elseif byte >= bytes.BYTE_0 and byte <= bytes.BYTE_9 then
         return nextNumberFractionPart(text, pos + 2)
      end
      return tokens.PERIOD, pos + 1
    end

    if byte == bytes.BYTE_LESSTHAN then
      byte = stringbyte(text, pos + 1)
      if byte == bytes.BYTE_EQUALS then
         return tokens.LTE, pos + 2
      end
      return tokens.LT, pos + 1
    end

    if byte == bytes.BYTE_GREATERTHAN then
      byte = stringbyte(text, pos + 1)
      if byte == bytes.BYTE_EQUALS then
         return tokens.GTE, pos + 2
      end
      return tokens.GT, pos + 1
    end

    if byte == bytes.BYTE_TILDE then
      byte = stringbyte(text, pos + 1)
      if byte == bytes.BYTE_EQUALS then
         return tokens.NOTEQUAL, pos + 2
      end
      return tokens.TILDE, pos + 1
    end

    return tokens.UNKNOWN, pos + 1
  elseif byte >= bytes.BYTE_0 and byte <= bytes.BYTE_9 then
    return nextNumberIntPart(text, pos + 1)
  else
    return nextIdentifier(text, pos + 1)
  end
end

   -- Cool stuff begins here! (indentation and highlighting)

local noIndentEffect = {0, 0}
local indentLeft = {-1, 0}
local indentRight = {0, 1}
local indentBoth = {-1, 1}

local keywords = {}
lib.keywords = keywords
keywords["and"] = noIndentEffect
keywords["break"] = noIndentEffect
keywords["false"] = noIndentEffect
keywords["for"] = noIndentEffect
keywords["if"] = noIndentEffect
keywords["in"] = noIndentEffect
keywords["local"] = noIndentEffect
keywords["nil"] = noIndentEffect
keywords["not"] = noIndentEffect
keywords["or"] = noIndentEffect
keywords["return"] = noIndentEffect
keywords["true"] = noIndentEffect
keywords["while"] = noIndentEffect

keywords["until"] = indentLeft
keywords["elseif"] = indentLeft
keywords["end"] = indentLeft

keywords["do"] = indentRight
keywords["then"] = indentRight
keywords["repeat"] = indentRight
keywords["function"] = indentRight

keywords["else"] = indentBoth

tokenIndentation = {}
lib.tokenIndentation = tokenIndentation
tokenIndentation[tokens.LEFTPAREN] = indentRight
tokenIndentation[tokens.LEFTBRACKET] = indentRight
tokenIndentation[tokens.LEFTWING] = indentRight

tokenIndentation[tokens.RIGHTPAREN] = indentLeft
tokenIndentation[tokens.RIGHTBRACKET] = indentLeft
tokenIndentation[tokens.RIGHTWING] = indentLeft

local function fillWithTabs(n)
  return stringrep("\t", n)
end

local function fillWithSpaces(a, b)
  return stringrep(" ", a*b)
end

function lib.colorCodeCode(code, colorTable, caretPosition)
  local stopColor = colorTable and colorTable[0]
  if not stopColor then
    return code, caretPosition
  end

  local stopColorLen = stringlen(stopColor)

  tableclear(workingTable)
  local tsize = 0
  local totalLen = 0
  local numLines = 0
  local newCaretPosition
  local prevTokenWasColored = false
  local prevTokenWidth = 0

  local pos = 1
  local level = 0

  while true do
    if caretPosition and not newCaretPosition and pos >= caretPosition then
      if pos == caretPosition then
         newCaretPosition = totalLen
      else
         newCaretPosition = totalLen
         local diff = pos - caretPosition
         if diff > prevTokenWidth then
      diff = prevTokenWidth
         end
         if prevTokenWasColored then
      diff = diff + stopColorLen
         end
         newCaretPosition = newCaretPosition - diff
      end
    end

    prevTokenWasColored = false
    prevTokenWidth = 0

    local tokenType, nextPos = nextToken(code, pos)

    if not tokenType then
      break
    end

    if tokenType == tokens.COLORCODE_START or tokenType == tokens.COLORCODE_STOP or tokenType == tokens.UNKNOWN then
      -- ignore color codes

    elseif tokenType == tokens.LINEBREAK or tokenType == tokens.WHITESPACE then
      if tokenType == tokens.LINEBREAK then
         numLines = numLines + 1
      end
      local str = stringsub(code, pos, nextPos - 1)
      prevTokenWidth = nextPos - pos

      tsize = tsize + 1
      workingTable[tsize] = str
      totalLen = totalLen + stringlen(str)
    else
      local str = stringsub(code, pos, nextPos - 1)

      prevTokenWidth = nextPos - pos

      -- Add coloring
      if keywords[str] then
         tokenType = tokens.KEYWORD
      end

      local color
      if stopColor then
         color = colorTable[str]
         if not color then
          color = colorTable[tokenType]
          if not color then
            if tokenType == tokens.IDENTIFIER then
              color = colorTable[tokens.IDENTIFIER]
            else
              color = colorTable[tokens.SPECIAL]
            end
          end
        end
      end

      if color then
        tsize = tsize + 1
        workingTable[tsize] = color
        tsize = tsize + 1
        workingTable[tsize] = str
        tsize = tsize + 1
        workingTable[tsize] = stopColor

        totalLen = totalLen + stringlen(color) + (nextPos - pos) + stopColorLen
        prevTokenWasColored = true
      else
        tsize = tsize + 1
        workingTable[tsize] = str

        totalLen = totalLen + stringlen(str)
      end
    end

    pos = nextPos
  end
  return table.concat(workingTable), newCaretPosition, numLines
end

function lib.indentCode(code, tabWidth, colorTable, caretPosition)
  local fillFunction
  if tabWidth == nil then
    tabWidth = defaultTabWidth
  end
  if tabWidth then
    fillFunction = fillWithSpaces
  else
    fillFunction = fillWithTabs
  end

  tableclear(workingTable)
  local tsize = 0
  local totalLen = 0
  tableclear(workingTable2)
  local tsize2 = 0
  local totalLen2 = 0

  local stopColor = colorTable and colorTable[0]
  local stopColorLen = not stopColor or stringlen(stopColor)

  local newCaretPosition
  local newCaretPositionFinalized = false
  local prevTokenWasColored = false
  local prevTokenWidth = 0

  local pos = 1
  local level = 0

  local hitNonWhitespace = false
  local hitIndentRight = false
  local preIndent = 0
  local postIndent = 0
  while true do
    if caretPosition and not newCaretPosition and pos >= caretPosition then
      if pos == caretPosition then
        newCaretPosition = totalLen + totalLen2
      else
        newCaretPosition = totalLen + totalLen2
        local diff = pos - caretPosition
        if diff > prevTokenWidth then
          diff = prevTokenWidth
        end
        if prevTokenWasColored then
          diff = diff + stopColorLen
        end
        newCaretPosition = newCaretPosition - diff
      end
    end

    prevTokenWasColored = false
    prevTokenWidth = 0

    local tokenType, nextPos = nextToken(code, pos)

    if not tokenType or tokenType == tokens.LINEBREAK then
      level = level + preIndent
      if level < 0 then level = 0 end

      local s = fillFunction(level, tabWidth)

      tsize = tsize + 1
      workingTable[tsize] = s
      totalLen = totalLen + stringlen(s)

      if newCaretPosition and not newCaretPositionFinalized then
        newCaretPosition = newCaretPosition + stringlen(s)
        newCaretPositionFinalized = true
      end


      for k, v in next,workingTable2 do
        tsize = tsize + 1
        workingTable[tsize] = v
        totalLen = totalLen + stringlen(v)
      end

      if not tokenType then
        break
      end

      tsize = tsize + 1
      workingTable[tsize] = stringsub(code, pos, nextPos - 1)
      totalLen = totalLen + nextPos - pos

      level = level + postIndent
      if level < 0 then level = 0 end

      tableclear(workingTable2)
      tsize2 = 0
      totalLen2 = 0

      hitNonWhitespace = false
      hitIndentRight = false
      preIndent = 0
      postIndent = 0
    elseif tokenType == tokens.WHITESPACE then
      if hitNonWhitespace then
        prevTokenWidth = nextPos - pos

        tsize2 = tsize2 + 1
        local s = stringsub(code, pos, nextPos - 1)
        workingTable2[tsize2] = s
        totalLen2 = totalLen2 + stringlen(s)
      end
    elseif tokenType == tokens.COLORCODE_START or tokenType == tokens.COLORCODE_STOP or tokenType == tokens.UNKNOWN then
      -- skip these, though they shouldn't be encountered here anyway
    else
      hitNonWhitespace = true

      local str = stringsub(code, pos, nextPos - 1)

      prevTokenWidth = nextPos - pos

      -- See if this is an indent-modifier
      local indentTable
      if tokenType == tokens.IDENTIFIER then
         indentTable = keywords[str]
      else
         indentTable = tokenIndentation[tokenType]
      end

      if indentTable then
        if hitIndentRight then
          postIndent = postIndent + indentTable[1] + indentTable[2]
        else
          local pre = indentTable[1]
          local post = indentTable[2]
          if post > 0 then
            hitIndentRight = true
          end
          preIndent = preIndent + pre
          postIndent = postIndent + post
        end
      end

      -- Add coloring
      if keywords[str] then
        tokenType = tokens.KEYWORD
      end

      local color
      if stopColor then
        color = colorTable[str]
        if not color then
          color = colorTable[tokenType]
          if not color then
            if tokenType == tokens.IDENTIFIER then
              color = colorTable[tokens.IDENTIFIER]
            else
              color = colorTable[tokens.SPECIAL]
            end
          end
        end
      end

      if color then
        tsize2 = tsize2 + 1
        workingTable2[tsize2] = color
        totalLen2 = totalLen2 + stringlen(color)

        tsize2 = tsize2 + 1
        workingTable2[tsize2] = str
        totalLen2 = totalLen2 + nextPos - pos

        tsize2 = tsize2 + 1
        workingTable2[tsize2] = stopColor
        totalLen2 = totalLen2 + stopColorLen

        prevTokenWasColored = true
      else
        tsize2 = tsize2 + 1
        workingTable2[tsize2] = str
        totalLen2 = totalLen2 + nextPos - pos

      end
   end
   pos = nextPos
  end
  return table.concat(workingTable), newCaretPosition
end


-- WoW specific code:
local GetTime = GetTime

local editboxSetText
local editboxGetText

-- Caret code (thanks Tem!)
local function critical_enter(editbox)
  local script = editbox:GetScript("OnTextSet")
  if script then
    editbox:SetScript("OnTextSet", nil)
  end
  return script
end

local function critical_leave(editbox, script)
  if script then
    editbox:SetScript("OnTextSet", script)
  end
end

local function setCaretPos_main(editbox, pos)
  local text = editboxGetText(editbox)

  if stringlen(text) > 0 then
    editboxSetText(editbox, stringinsert(text, pos, "a"))
    editbox:HighlightText(pos, pos + 1)
    editbox:Insert("\0")
  end
end

local function getCaretPos(editbox)
  local script = critical_enter(editbox)

  local text = editboxGetText(editbox)
  editbox:Insert("\1")
  local pos = stringfind(editboxGetText(editbox), "\1", 1, 1)
  editboxSetText(editbox, text)

  if pos then
    setCaretPos_main(editbox, pos - 1)
  end
  critical_leave(editbox, script)

  return (pos or 0) - 1
end

local function setCaretPos(editbox, pos)
  local script = critical_enter(editbox)
  setCaretPos_main(editbox, pos)
  critical_leave(editbox, script, script2)
end
-- end of caret code

function lib.stripWowColors(code)

  -- HACK!
  -- This is a fix for a bug, where an unfinished string causes a lot of newlines to be created.
  -- The reason for the bug, is that a |r\n\n gets converted to \n\n|r after the next indent-run
  -- The fix is to remove those last two linebreaks when stripping
  code = stringgsub(code, "|r\n\n$", "|r")

  tableclear(workingTable)
  local tsize = 0
  local pos = 1

  local prevVertical = false
  local even = true
  local selectionStart = 1

  while true do
    local byte = stringbyte(code, pos)
    if not byte then
      break
    end
    if byte == bytes.BYTE_VERTICAL then
      even = not even
      prevVertical = true
    else
      if prevVertical and not even then
        if byte == bytes.BYTE_c then

          if pos - 2 >= selectionStart then
            tsize = tsize + 1
            workingTable[tsize] = stringsub(code, selectionStart, pos - 2)
          end

          pos = pos + 8
          selectionStart = pos + 1
        elseif byte == bytes.BYTE_r then

          if pos - 2 >= selectionStart then
            tsize = tsize + 1
            workingTable[tsize] = stringsub(code, selectionStart, pos - 2)
          end
          selectionStart = pos + 1
        end
      end
      prevVertical = false
      even = true
    end
    pos = pos + 1
  end
  if pos >= selectionStart then
    tsize = tsize + 1
    workingTable[tsize] = stringsub(code, selectionStart, pos - 1)
  end
  return table.concat(workingTable)
end

function lib.decode(code)
  if code then
    code = lib.stripWowColors(code)
    code = stringgsub(code, "||", "|")
  end
  return code or ""
end

function lib.encode(code)
  if code then
    code = stringgsub(code, "|", "||")
  end
  return code or ""
end

function lib.stripWowColorsWithPos(code, pos)
  code = stringinsert(code, pos, "\2")
  code = lib.stripWowColors(code)
  pos = stringfind(code, "\2", 1, 1)
  code = stringdelete(code, pos, pos)
  return code, pos
end

-- returns the padded code, and true if modified, false if unmodified
local linebreak = stringbyte("\n")
function lib.padWithLinebreaks(code)
  local len = stringlen(code)
    if stringbyte(code, len) == linebreak then
      if stringbyte(code, len - 1) == linebreak then
        return code, false
      end
    return code .. "\n", true
    end
  return code .. "\n\n", true
end

local defaultTabWidth = 2
local defaultColorTable

-- Data tables
-- No weak table magic, since editboxes can never be removed in WoW
local enabled = {}
local dirty = {}

local editboxIndentCache = {}
local decodeCache = {}
local editboxStringCache = {}
local editboxNumLinesCache = {}

function lib.colorCodeEditbox(editbox)
  dirty[editbox] = nil

  local colorTable = editbox.faiap_colorTable or defaultColorTable
  local tabWidth = editbox.faiap_tabWidth

  local orgCode = editboxGetText(editbox)
  local prevCode = editboxStringCache[editbox]
  if prevCode == orgCode then
    return
  end

  local pos = getCaretPos(editbox)

  local code
  code, pos = lib.stripWowColorsWithPos(orgCode, pos)

  colorTable[0] = "|r"

  local newCode, newPos, numLines = lib.colorCodeCode(code, colorTable, pos)
  newCode = lib.padWithLinebreaks(newCode)

  editboxStringCache[editbox] = newCode
  if orgCode ~= newCode then
    local script, script2 = critical_enter(editbox)
    decodeCache[editbox] = nil
    local stringlenNewCode = stringlen(newCode)

    editboxSetText(editbox, newCode)
    if newPos then
      if newPos < 0 then newPos = 0 end
      if newPos > stringlenNewCode then newPos = stringlenNewCode end

      setCaretPos(editbox, newPos)
    end
    critical_leave(editbox, script, script2)
  end

  if editboxNumLinesCache[editbox] ~= numLines then
    lib.indentEditbox(editbox)
  end
  editboxNumLinesCache[editbox] = numLines
end

function lib.indentEditbox(editbox)
  dirty[editbox] = nil

  local colorTable = editbox.faiap_colorTable or defaultColorTable
  local tabWidth = editbox.faiap_tabWidth

  local orgCode = editboxGetText(editbox)
  local prevCode = editboxIndentCache[editbox]
  if prevCode == orgCode then
    return
  end

  local pos = getCaretPos(editbox)

  local code
  code, pos = lib.stripWowColorsWithPos(orgCode, pos)

  colorTable[0] = "|r"
  local newCode, newPos = lib.indentCode(code, tabWidth, colorTable, pos)
  newCode = lib.padWithLinebreaks(newCode)
  editboxIndentCache[editbox] = newCode
  if code ~= newCode then
    local script, script2 = critical_enter(editbox)
    decodeCache[editbox] = nil

    local stringlenNewCode = stringlen(newCode)

    editboxSetText(editbox, newCode)

    if newPos then
      if newPos < 0 then newPos = 0 end
      if newPos > stringlenNewCode then newPos = stringlenNewCode end

      setCaretPos(editbox, newPos)
    end
    critical_leave(editbox, script, script2)
  end
end

local function hookHandler(editbox, handler, newFun)
  local oldFun = editbox:GetScript(handler)
  if oldFun == newFun then
    -- already hooked, ignore it
    return
  end
  editbox["faiap_old_" .. handler] = oldFun
  editbox:SetScript(handler, newFun)
end

local function textChangedHook(editbox, ...)
  local oldFun = editbox["faiap_old_OnTextChanged"]
  if oldFun then
    oldFun(editbox, ...)
  end
  if enabled[editbox] then
    dirty[editbox] = GetTime()
  end
end

local function tabPressedHook(editbox, ...)
  local oldFun = editbox["faiap_old_OnTabPressed"]
  if oldFun then
    oldFun(editbox, ...)
  end
  if enabled[editbox] then
    return lib.indentEditbox(editbox)
  end
end

local function onUpdateHook(editbox, ...)
  local oldFun = editbox["faiap_old_OnUpdate"]
  if oldFun then
    oldFun(editbox, ...)
  end
  if enabled[editbox] then
    local now = GetTime()
    local lastUpdate = dirty[editbox] or now
    if now - lastUpdate > 0.2 then
      decodeCache[editbox] = nil
      return lib.colorCodeEditbox(editbox)
    end
  end
end

local function newGetText(editbox)
  local decoded = decodeCache[editbox]
  if not decoded then
    decoded = lib.decode(editboxGetText(editbox))
    decodeCache[editbox] = decoded
  end
  return decoded or ""
end

local function newSetText(editbox, text)
  decodeCache[editbox] = nil
  if text then
    local encoded = lib.encode(text)

    return editboxSetText(editbox, encoded)
  end
end

function lib.enable(editbox, colorTable, tabWidth)
  if not editboxSetText then
    editboxSetText = editbox.SetText
    editboxGetText = editbox.GetText
  end

  local modified
  if editbox.faiap_colorTable ~= colorTable then
    editbox.faiap_colorTable = colorTable
    modified = true
  end
  if editbox.faiap_tabWidth ~= tabWidth then
    editbox.faiap_tabWidth = tabWidth
    modified = true
  end

  if enabled[editbox] then
    if modified then
      lib.indentEditbox(editbox)
    end
    return
  end

  -- Editbox is possibly hooked, but disabled
  enabled[editbox] = true

  editbox.oldMaxBytes = editbox:GetMaxBytes()
  editbox.oldMaxLetters = editbox:GetMaxLetters()
  editbox:SetMaxBytes(0)
  editbox:SetMaxLetters(0)

  editbox.GetText = newGetText
  editbox.SetText = newSetText

  hookHandler(editbox, "OnTextChanged", textChangedHook)
  hookHandler(editbox, "OnTabPressed", tabPressedHook)
  hookHandler(editbox, "OnUpdate", onUpdateHook)

  lib.indentEditbox(editbox)
end

-- Deprecated function
lib.addSmartCode = lib.enable

function lib.disable(editbox)
  if not enabled[editbox] then
    return
  end
  enabled[editbox] = nil

  -- revert settings for max bytes / letters
  editbox:SetMaxBytes(editbox.oldMaxBytes)
  editbox:SetMaxLetters(editbox.oldMaxLetters)

  -- try a real unhooking, if possible
  if editbox:GetScript("OnTextChanged") == textChangedHook then
    editbox:SetScript("OnTextChanged", editbox.faiap_old_OnTextChanged)
    editbox.faiap_old_OnTextChanged = nil
  end

  if editbox:GetScript("OnTabPressed") == tabPressedHook then
    editbox:SetScript("OnTabPressed", editbox.faiap_old_OnTabPressed)
    editbox.faiap_old_OnTabPressed = nil
  end

  if editbox:GetScript("OnUpdate") == onUpdateHook then
    editbox:SetScript("OnUpdate", editbox.faiap_old_OnUpdate)
    editbox.faiap_old_OnUpdate = nil
  end

  editbox.GetText = nil
  editbox.SetText = nil

  -- change the text back to unformatted
  editbox:SetText(newGetText(editbox))

  -- clear caches
  editboxIndentCache[editbox] = nil
  decodeCache[editbox] = nil
  editboxStringCache[editbox] = nil
  editboxNumLinesCache[editbox] = nil
end

defaultColorTable = {}
lib.defaultColorTable = defaultColorTable
defaultColorTable[tokens.SPECIAL] = "|c00ff99ff"
defaultColorTable[tokens.KEYWORD] = "|c006666ff"
defaultColorTable[tokens.COMMENT_SHORT] = "|c00999999"
defaultColorTable[tokens.COMMENT_LONG] = "|c00999999"

local stringColor = "|c00ffff77"
defaultColorTable[tokens.STRING] = stringColor
defaultColorTable[".."] = stringColor

local tableColor = "|c00ff9900"
defaultColorTable["..."] = tableColor
defaultColorTable["{"] = tableColor
defaultColorTable["}"] = tableColor
defaultColorTable["["] = tableColor
defaultColorTable["]"] = tableColor

local arithmeticColor = "|c0033ff55"
defaultColorTable[tokens.NUMBER] = arithmeticColor
defaultColorTable["+"] = arithmeticColor
defaultColorTable["-"] = arithmeticColor
defaultColorTable["/"] = arithmeticColor
defaultColorTable["*"] = arithmeticColor

local logicColor1 = "|c0055ff88"
defaultColorTable["=="] = logicColor1
defaultColorTable["<"] = logicColor1
defaultColorTable["<="] = logicColor1
defaultColorTable[">"] = logicColor1
defaultColorTable[">="] = logicColor1
defaultColorTable["~="] = logicColor1

local logicColor2 = "|c0088ffbb"
defaultColorTable["and"] = logicColor2
defaultColorTable["or"] = logicColor2
defaultColorTable["not"] = logicColor2

defaultColorTable[0] = "|r"

end

-- just for testing
--[[
function testTokenizer()
   local str = ""
   for line in io.lines("indent.lua") do
      str = str .. line .. "\n"
   end

   local pos = 1

   while true do
      local tokenType, nextPos = nextToken(str, pos)

      if not tokenType then
   break
      end

      if true or tokenType ~= tokens.WHITESPACE and tokenType ~= tokens.LINEBREAK then
   print(stringformat("Found token %d (%d-%d): (%s)", tokenType, pos, nextPos - 1, stringsub(str, pos, nextPos - 1)))
      end

      if tokenType == tokens.UNKNOWN then
   print("unknown token!")
   break
      end

      pos = nextPos
   end
end


function testIndenter(i)
   local lib = IndentationLib
   local str = ""
   for line in io.lines("test.lua") do
      str = str .. line .. "\n"
   end

   local colorTable = lib.defaultColorTable
   print(lib.indentCode(str, 4, colorTable, i))
end


testIndenter()

--]]