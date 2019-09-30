#Errors lib.
import ../../../lib/Errors

#Hash lib.
import ../../../lib/Hash

#MinerWallet lib.
import ../../../Wallet/MinerWallet

#Verification object.
import ../../../Database/Consensus/Elements/objects/VerificationObj

#Serialize/Deserialize functions.
import ../SerializeCommon

#Parse a Verification.
proc parseVerification*(
    verifStr: string
): Verification {.forceCheck: [
    ValueError
].} =
    #Holder's Nickname | Transaction Hash
    var verifSeq: seq[string] = verifStr.deserialize(
        INT_LEN,
        HASH_LEN
    )

    #Create the Verification.
    try:
        result = newVerificationObj(
            verifSeq[1].toHash(384)
        )
        result.holder = uint32(verifSeq[0].fromBinary())
    except ValueError as e:
        fcRaise e
    except FinalAttributeError as e:
        doAssert(false, "Set a final attribute twice when parsing a Verification: " & e.msg)

#Parse a Signed Verification.
proc parseSignedVerification*(
    verifStr: string
): SignedVerification {.forceCheck: [
    ValueError,
    BLSError
].} =
    #Holder's Nickname | Transaction Hash | BLS Signature
    var verifSeq: seq[string] = verifStr.deserialize(
        INT_LEN,
        HASH_LEN,
        BLS_SIGNATURE_LEN
    )

    #Create the Verification.
    try:
        result = newSignedVerificationObj(
            verifSeq[1].toHash(384)
        )
        result.holder = uint32(verifSeq[0].fromBinary())
        result.signature = newBLSSignature(verifSeq[2])
    except ValueError as e:
        fcRaise e
    except BLSError as e:
        fcRaise e
    except FinalAttributeError as e:
        doAssert(false, "Set a final attribute twice when parsing a Signed Verification: " & e.msg)
