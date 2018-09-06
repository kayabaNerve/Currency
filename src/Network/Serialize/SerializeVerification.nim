#Numerical libs.
import BN
import ../../lib/Base

#Address lib.
import ../../Wallet/Address

#Verification object.
import ../../Database/Lattice/objects/NodeObj
import ../../Database/Lattice/objects/VerificationObj

#Common serialization functions.
import SerializeCommon

#Serialize a Verification.
proc serialize*(verif: Verification): string =
    result =
        verif.getNonce().toString(255) !
        Address.toBN(verif.getAddress()).toString(255) !
        verif.getIndex().toString(255) !
        verif.getVerified().toBN(16).toString(255)

    if verif.getHash().len != 0:
        result =
            Address.toBN(verif.getSender()).toString(255) !
            result !
            verif.getSignature().toBN(16).toString(255)

        result = result.toBN(256).toString(253)
