#Hash master type.
import HashCommon

#nimcrypto lib.
import nimcrypto

#String utils standard lib.
import strutils

#Define the Hash Types.
type
    SHA3_256Hash* = HashCommon.Hash[256]
    SHA3_512Hash* = HashCommon.Hash[512]

#SHA3 256 hashing algorithm.
proc SHA3_256*(bytesArg: string): SHA3_256Hash {.raises: [].} =
    #Copy the bytes argument.
    var bytes: string = bytesArg

    #If it's an empty string...
    if bytes.len == 0:
        return SHA3_256Hash(
            data: sha3_256.digest(empty, uint(bytes.len)).data
        )

    #Digest the byte array.
    result = SHA3_256Hash(
        data: sha3_256.digest(cast[ptr uint8](addr bytes[0]), uint(bytes.len)).data
    )

#SHA3 512 hashing algorithm.
proc SHA3_512*(bytesArg: string): SHA3_512Hash {.raises: [].} =
    #Copy the bytes argument.
    var bytes: string = bytesArg

    #If it's an empty string...
    if bytes.len == 0:
        return SHA3_512Hash(
            data: sha3_512.digest(empty, uint(bytes.len)).data
        )

    #Digest the byte array.
    result = SHA3_512Hash(
        data: sha3_512.digest(cast[ptr uint8](addr bytes[0]), uint(bytes.len)).data
    )

#String to SHA3_256Hash.
proc toSHA3_256Hash*(hex: string): SHA3_256Hash =
    for i in countup(0, hex.len - 1, 2):
        result.data[int(i / 2)] = uint8(parseHexInt(hex[i .. i + 1]))

#String to SHA3_512Hash.
proc toSHA3_512Hash*(hex: string): SHA3_512Hash =
    for i in countup(0, hex.len - 1, 2):
        result.data[int(i / 2)] = uint8(parseHexInt(hex[i .. i + 1]))
