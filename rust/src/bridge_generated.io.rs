use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_secret_key_from_seed(port_: i64, seed: *mut wire_uint_8_list) {
    wire_secret_key_from_seed_impl(port_, seed)
}

#[no_mangle]
pub extern "C" fn wire_secret_key_public_key(port_: i64, sk: *mut wire_uint_8_list) {
    wire_secret_key_public_key_impl(port_, sk)
}

#[no_mangle]
pub extern "C" fn wire_secret_key_derive_path_hardened(
    port_: i64,
    sk: *mut wire_uint_8_list,
    path: *mut wire_uint_32_list,
) {
    wire_secret_key_derive_path_hardened_impl(port_, sk, path)
}

#[no_mangle]
pub extern "C" fn wire_secret_key_derive_path_unhardened(
    port_: i64,
    sk: *mut wire_uint_8_list,
    path: *mut wire_uint_32_list,
) {
    wire_secret_key_derive_path_unhardened_impl(port_, sk, path)
}

#[no_mangle]
pub extern "C" fn wire_public_key_derive_path_unhardened(
    port_: i64,
    sk: *mut wire_uint_8_list,
    path: *mut wire_uint_32_list,
) {
    wire_public_key_derive_path_unhardened_impl(port_, sk, path)
}

#[no_mangle]
pub extern "C" fn wire_signature_sign(
    port_: i64,
    sk: *mut wire_uint_8_list,
    msg: *mut wire_uint_8_list,
) {
    wire_signature_sign_impl(port_, sk, msg)
}

#[no_mangle]
pub extern "C" fn wire_signature_is_valid(port_: i64, sig: *mut wire_uint_8_list) {
    wire_signature_is_valid_impl(port_, sig)
}

#[no_mangle]
pub extern "C" fn wire_signature_aggregate(
    port_: i64,
    sigs_stream: *mut wire_uint_8_list,
    length: usize,
) {
    wire_signature_aggregate_impl(port_, sigs_stream, length)
}

#[no_mangle]
pub extern "C" fn wire_signature_verify(
    port_: i64,
    pk: *mut wire_uint_8_list,
    msg: *mut wire_uint_8_list,
    sig: *mut wire_uint_8_list,
) {
    wire_signature_verify_impl(port_, pk, msg, sig)
}

#[no_mangle]
pub extern "C" fn wire_pub_mnemonic_to_entropy(port_: i64, mnemonic_words: *mut wire_uint_8_list) {
    wire_pub_mnemonic_to_entropy_impl(port_, mnemonic_words)
}

#[no_mangle]
pub extern "C" fn wire_pub_entropy_to_mnemonic(port_: i64, entropy: *mut wire_uint_8_list) {
    wire_pub_entropy_to_mnemonic_impl(port_, entropy)
}

#[no_mangle]
pub extern "C" fn wire_pub_entropy_to_seed(port_: i64, entropy: *mut wire_uint_8_list) {
    wire_pub_entropy_to_seed_impl(port_, entropy)
}

#[no_mangle]
pub extern "C" fn wire_bytes_to_hex(port_: i64, bytes: *mut wire_uint_8_list) {
    wire_bytes_to_hex_impl(port_, bytes)
}

#[no_mangle]
pub extern "C" fn wire_hex_to_bytes(port_: i64, hex: *mut wire_uint_8_list) {
    wire_hex_to_bytes_impl(port_, hex)
}

#[no_mangle]
pub extern "C" fn wire_bytes_to_sha256(port_: i64, bytes: *mut wire_uint_8_list) {
    wire_bytes_to_sha256_impl(port_, bytes)
}

#[no_mangle]
pub extern "C" fn wire_pub_master_to_wallet_unhardened_intermediate(
    port_: i64,
    master: *mut wire_uint_8_list,
) {
    wire_pub_master_to_wallet_unhardened_intermediate_impl(port_, master)
}

#[no_mangle]
pub extern "C" fn wire_pub_master_to_wallet_unhardened(
    port_: i64,
    master: *mut wire_uint_8_list,
    idx: u32,
) {
    wire_pub_master_to_wallet_unhardened_impl(port_, master, idx)
}

#[no_mangle]
pub extern "C" fn wire_pub_master_to_wallet_hardened_intermediate(
    port_: i64,
    master: *mut wire_uint_8_list,
) {
    wire_pub_master_to_wallet_hardened_intermediate_impl(port_, master)
}

#[no_mangle]
pub extern "C" fn wire_pub_master_to_wallet_hardened(
    port_: i64,
    master: *mut wire_uint_8_list,
    idx: u32,
) {
    wire_pub_master_to_wallet_hardened_impl(port_, master, idx)
}

#[no_mangle]
pub extern "C" fn wire_pub_master_to_pool_singleton(
    port_: i64,
    master: *mut wire_uint_8_list,
    pool_wallet_idx: u32,
) {
    wire_pub_master_to_pool_singleton_impl(port_, master, pool_wallet_idx)
}

#[no_mangle]
pub extern "C" fn wire_pub_master_to_pool_authentication(
    port_: i64,
    sk: *mut wire_uint_8_list,
    pool_wallet_idx: u32,
    idx: u32,
) {
    wire_pub_master_to_pool_authentication_impl(port_, sk, pool_wallet_idx, idx)
}

#[no_mangle]
pub extern "C" fn wire_cmds_program_run(port_: i64, args: *mut wire_StringList) {
    wire_cmds_program_run_impl(port_, args)
}

#[no_mangle]
pub extern "C" fn wire_cmds_program_brun(port_: i64, args: *mut wire_StringList) {
    wire_cmds_program_brun_impl(port_, args)
}

#[no_mangle]
pub extern "C" fn wire_cmd_program_opc(port_: i64, args: *mut wire_StringList) {
    wire_cmd_program_opc_impl(port_, args)
}

#[no_mangle]
pub extern "C" fn wire_cmd_program_opd(port_: i64, args: *mut wire_StringList) {
    wire_cmd_program_opd_impl(port_, args)
}

#[no_mangle]
pub extern "C" fn wire_cmd_program_cldb(port_: i64, args: *mut wire_StringList) {
    wire_cmd_program_cldb_impl(port_, args)
}

#[no_mangle]
pub extern "C" fn wire_program_tree_hash(port_: i64, program_bytes: *mut wire_uint_8_list) {
    wire_program_tree_hash_impl(port_, program_bytes)
}

#[no_mangle]
pub extern "C" fn wire_program_curry(
    port_: i64,
    program_bytes: *mut wire_uint_8_list,
    args_str: *mut wire_StringList,
) {
    wire_program_curry_impl(port_, program_bytes, args_str)
}

#[no_mangle]
pub extern "C" fn wire_program_uncurry(port_: i64, program_bytes: *mut wire_uint_8_list) {
    wire_program_uncurry_impl(port_, program_bytes)
}

#[no_mangle]
pub extern "C" fn wire_program_from_list(port_: i64, program_list: *mut wire_StringList) {
    wire_program_from_list_impl(port_, program_list)
}

#[no_mangle]
pub extern "C" fn wire_program_disassemble(port_: i64, program_bytes: *mut wire_uint_8_list) {
    wire_program_disassemble_impl(port_, program_bytes)
}

#[no_mangle]
pub extern "C" fn wire_program_run(
    port_: i64,
    program_bytes: *mut wire_uint_8_list,
    args_str: *mut wire_StringList,
) {
    wire_program_run_impl(port_, program_bytes, args_str)
}

#[no_mangle]
pub extern "C" fn wire_get_puzzle_from_public_key(port_: i64, pk: *mut wire_uint_8_list) {
    wire_get_puzzle_from_public_key_impl(port_, pk)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_StringList_0(len: i32) -> *mut wire_StringList {
    let wrap = wire_StringList {
        ptr: support::new_leak_vec_ptr(<*mut wire_uint_8_list>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_uint_32_list_0(len: i32) -> *mut wire_uint_32_list {
    let ans = wire_uint_32_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}
impl Wire2Api<Vec<String>> for *mut wire_StringList {
    fn wire2api(self) -> Vec<String> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}

impl Wire2Api<Vec<u32>> for *mut wire_uint_32_list {
    fn wire2api(self) -> Vec<u32> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}
impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}

// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_StringList {
    ptr: *mut *mut wire_uint_8_list,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_32_list {
    ptr: *mut u32,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
