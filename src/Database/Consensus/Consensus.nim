#Errors.
import ../../lib/Errors

#Hash lib.
import ../../lib/Hash

#MinerWallet lib.
import ../../Wallet/MinerWallet

#Consensus DB lib.
import ../Filesystem/DB/ConsensusDB

#Merkle lib.
import ../common/Merkle

#ConsensusIndex and MeritHolderRecord objects.
import ../common/objects/ConsensusIndexObj
import ../common/objects/MeritHolderRecordObj
export ConsensusIndex

#Signed Element object.
import objects/SignedElementObj
export SignedElementObj

#Element and MeritHolder libs.
import Element
import MeritHolder
export Element
export MeritHolder

#Consensus object.
import objects/ConsensusObj
export ConsensusObj

#Seq utils standard lib.
import sequtils

#Tables standard lib.
import tables

#Constructor wrapper.
proc newConsensus*(
    db: DB
): Consensus {.forceCheck: [].} =
    newConsensusObj(db)

#Add a Verification.
proc add*(
    consensus: Consensus,
    verif: Verification
) {.forceCheck: [
    GapError,
    DataExists,
    MaliciousMeritHolder
].} =
    try:
        consensus[verif.holder].add(verif)
    except GapError as e:
        fcRaise e
    except DataExists as e:
        fcRaise e
    except MaliciousMeritHolder as e:
        fcRaise e

#Add a SignedVerification.
proc add*(
    consensus: Consensus,
    verif: SignedVerification
) {.forceCheck: [
    ValueError,
    GapError,
    BLSError,
    DataExists,
    MaliciousMeritHolder
].} =
    try:
        consensus[verif.holder].add(verif)
    except ValueError as e:
        fcRaise e
    except GapError as e:
        fcRaise e
    except BLSError as e:
        fcRaise e
    except DataExists as e:
        fcRaise e
    except MaliciousMeritHolder as e:
        fcRaise e

#For each provided Record, archive all Elements from the account's last archived to the provided nonce.
proc archive*(
    consensus: Consensus,
    records: seq[MeritHolderRecord]
) {.forceCheck: [].} =
    #Iterate over every Record.
    for record in records:
        #Make sure this MeritHolder has Elements to archive.
        if consensus[record.key].elements.len == 0:
            doAssert(false, "Tried to archive Elements from a MeritHolder without any pending Elements.")

        #Make sure this MeritHolder has enough Elements.
        if record.nonce > consensus[record.key].elements[0].nonce + consensus[record.key].elements.len - 1:
            doAssert(false, "Tried to archive more Elements than this MeritHolder has pending.")

        #Delete them from the seq.
        consensus[record.key].elements.delete(
            0,
            record.nonce - consensus[record.key].elements[0].nonce
        )

        #Reset the Merkle.
        consensus[record.key].merkle = newMerkle()
        for element in consensus[record.key].elements:
            case elem:
                of Verification as verif:
                    consensus[record.key].merkle.add(verif.hash)
                else:
                    doAssert(false, "Element should be a Verification.")

        #Update the archived field.
        consensus[record.key].archived = record.nonce

        #Update the DB.
        try:
            consensus.db.save(record.key, record.nonce)
        except DBWriteError as e:
            doAssert(false, "Couldn't save a MeritHolder's tip to the Database: " & e.msg)
