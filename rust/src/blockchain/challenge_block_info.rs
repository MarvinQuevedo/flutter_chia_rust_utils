use crate::blockchain::proof_of_space::ProofOfSpace;
use crate::blockchain::sized_bytes::Bytes96;
use crate::blockchain::vdf_info::VdfInfo;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct ChallengeBlockInfo {
    pub proof_of_space: ProofOfSpace,
    pub challenge_chain_sp_vdf: Option<VdfInfo>,
    pub challenge_chain_sp_signature: Bytes96,
    pub challenge_chain_ip_vdf: VdfInfo,
}
