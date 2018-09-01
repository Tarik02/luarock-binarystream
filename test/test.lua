local BinaryStream = require "../src/binarystream"

--[[
	Tests are still not complete
]]

function string.fromhex(str)
	return (str:gsub('..', function (cc)
		return string.char(tonumber(cc, 16))
	end))
end

function string.tohex(str)
	return (str:gsub('.', function (c)
		return string.format('%02X', string.byte(c))
	end))
end

describe("BinaryStream", function()
	describe("raw", function()
		it("should read", function()
			assert_equal(
				BinaryStream(string.fromhex("5C0F3BAD")):readRaw(3):tohex(),
				"5C0F3B"
			)
		end)
	
		it("should write", function()
			assert_equal(
				BinaryStream():writeRaw(string.fromhex("5C0F33")):string():tohex(),
				"5C0F33"
			)
		end)
	end)

	describe("bool", function()
		it("should read 00 as false", function()
			assert_equal(
				BinaryStream(string.fromhex("00")):readBool(),
				false
			)
		end)

		it("should read 45 as false", function()
			assert_equal(
				BinaryStream(string.fromhex("45")):readBool(),
				false
			)
		end)

		it("should read FF as true", function()
			assert_equal(
				BinaryStream(string.fromhex("FF")):readBool(),
				true
			)
		end)
	
		it("should write false as 00", function()
			assert_equal(
				BinaryStream():writeBool(false):string():tohex(),
				"00"
			)
		end)

		it("should write true as FF", function()
			assert_equal(
				BinaryStream():writeBool(true):string():tohex(),
				"FF"
			)
		end)
	end)

	describe("u8", function()
		it("should read", function()
			assert_equal(
				BinaryStream(string.fromhex("5C")):readU8(),
				0x5C
			)
		end)

		it("should write", function()
			assert_equal(
				BinaryStream():writeU8(0x5C):string():tohex(),
				"5C"
			)
		end)
	end)

	describe("s8", function()
		it("should read positive", function()
			assert_equal(
				BinaryStream(string.fromhex("3C")):readS8(),
				60
			)
		end)

		it("should write positive", function()
			assert_equal(
				BinaryStream():writeS8(60):string():tohex(),
				"3C"
			)
		end)

		it("should read negative", function()
			assert_equal(
				BinaryStream(string.fromhex("9A")):readS8(),
				-102
			)
		end)

		it("should write negative", function()
			assert_equal(
				BinaryStream():writeS8(-102):string():tohex(),
				"9A"
			)
		end)
	end)

	describe("little", function()
		describe("u16", function()
			it("should read", function()
				assert_equal(
					BinaryStream(string.fromhex("ABCD"), nil, {endianess = "le"}):readU16(),
					52651
				)
			end)

			it("should write", function()
				assert_equal(
					BinaryStream(nil, nil, {endianess = "le"}):writeU16(52651):string():tohex(),
					"ABCD"
				)
			end)
		end)

		describe("var s32", function()
			it("should read negative", function()
				assert_equal(
					BinaryStream(string.fromhex("BB9C04"), nil, {endianess = "le"}):readVarS32(),
					-34589
				)
			end)

			it("should write negative", function()
				assert_equal(
					BinaryStream(nil, nil, {endianess = "le"}):writeVarS32(-34589):string():tohex(),
					"BB9C04"
				)
			end)

			it("should read positive", function()
				assert_equal(
					BinaryStream(string.fromhex("BA9C04"), nil, {endianess = "le"}):readVarS32(),
					34589
				)
			end)

			it("should write positive", function()
				assert_equal(
					BinaryStream(nil, nil, {endianess = "le"}):writeVarS32(34589):string():tohex(),
					"BA9C04"
				)
			end)
		end)

		describe("var u32", function()
			it("should read", function()
				assert_equal(
					BinaryStream(string.fromhex("9D8E02"), nil, {endianess = "le"}):readVarU32(),
					34589
				)
			end)

			it("should write", function()
				assert_equal(
					BinaryStream(nil, nil, {endianess = "le"}):writeVarU32(34589):string():tohex(),
					"9D8E02"
				)
			end)
		end)
	end)

	describe("string", function()
		it("should read", function()
			assert_equal(
				BinaryStream(string.fromhex("0748692C206D616E")):readString(),
				"Hi, man"
			)
		end)
		
		it("should write", function()
			assert_equal(
				BinaryStream():writeString("Hi, man"):string():tohex(),
				"0748692C206D616E"
			)
		end)
	end)
end)
