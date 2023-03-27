#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

#define INFINITE_COST 9223372036854775807

#define NUMBER_ZERO_BITS_PLOT_FILTER 9

#define K_BC (K_B * K_C)

typedef struct DartCObject DartCObject;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_uint_32_list {
  uint32_t *ptr;
  int32_t len;
} wire_uint_32_list;

typedef struct wire_StringList {
  struct wire_uint_8_list **ptr;
  int32_t len;
} wire_StringList;

typedef struct DartCObject *WireSyncReturn;

void enforce_binding(void);

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_secret_key_from_seed(int64_t port_, struct wire_uint_8_list *seed);

void wire_secret_key_public_key(int64_t port_, struct wire_uint_8_list *sk);

void wire_secret_key_derive_path_hardened(int64_t port_,
                                          struct wire_uint_8_list *sk,
                                          struct wire_uint_32_list *path);

void wire_secret_key_derive_path_unhardened(int64_t port_,
                                            struct wire_uint_8_list *sk,
                                            struct wire_uint_32_list *path);

void wire_public_key_derive_path_unhardened(int64_t port_,
                                            struct wire_uint_8_list *sk,
                                            struct wire_uint_32_list *path);

void wire_signature_sign(int64_t port_, struct wire_uint_8_list *sk, struct wire_uint_8_list *msg);

void wire_signature_is_valid(int64_t port_, struct wire_uint_8_list *sig);

void wire_signature_aggregate(int64_t port_,
                              struct wire_uint_8_list *sigs_stream,
                              uintptr_t length);

void wire_signature_verify(int64_t port_,
                           struct wire_uint_8_list *pk,
                           struct wire_uint_8_list *msg,
                           struct wire_uint_8_list *sig);

void wire_pub_mnemonic_to_entropy(int64_t port_, struct wire_uint_8_list *mnemonic_words);

void wire_pub_entropy_to_mnemonic(int64_t port_, struct wire_uint_8_list *entropy);

void wire_pub_entropy_to_seed(int64_t port_, struct wire_uint_8_list *entropy);

void wire_bytes_to_hex(int64_t port_, struct wire_uint_8_list *bytes);

void wire_hex_to_bytes(int64_t port_, struct wire_uint_8_list *hex);

void wire_bytes_to_sha256(int64_t port_, struct wire_uint_8_list *bytes);

void wire_pub_master_to_wallet_unhardened_intermediate(int64_t port_,
                                                       struct wire_uint_8_list *master);

void wire_pub_master_to_wallet_unhardened(int64_t port_,
                                          struct wire_uint_8_list *master,
                                          uint32_t idx);

void wire_pub_master_to_wallet_hardened_intermediate(int64_t port_,
                                                     struct wire_uint_8_list *master);

void wire_pub_master_to_wallet_hardened(int64_t port_,
                                        struct wire_uint_8_list *master,
                                        uint32_t idx);

void wire_pub_master_to_pool_singleton(int64_t port_,
                                       struct wire_uint_8_list *master,
                                       uint32_t pool_wallet_idx);

void wire_pub_master_to_pool_authentication(int64_t port_,
                                            struct wire_uint_8_list *sk,
                                            uint32_t pool_wallet_idx,
                                            uint32_t idx);

void wire_cmds_program_run(int64_t port_, struct wire_StringList *args);

void wire_cmds_program_brun(int64_t port_, struct wire_StringList *args);

void wire_cmd_program_opc(int64_t port_, struct wire_StringList *args);

void wire_cmd_program_opd(int64_t port_, struct wire_StringList *args);

void wire_cmd_program_cldb(int64_t port_, struct wire_StringList *args);

void wire_program_tree_hash(int64_t port_, struct wire_uint_8_list *program_bytes);

void wire_program_curry(int64_t port_,
                        struct wire_uint_8_list *program_bytes,
                        struct wire_StringList *args_str);

void wire_program_uncurry(int64_t port_, struct wire_uint_8_list *program_bytes);

void wire_program_from_list(int64_t port_, struct wire_StringList *program_list);

void wire_program_disassemble(int64_t port_, struct wire_uint_8_list *program_bytes);

void wire_program_run(int64_t port_,
                      struct wire_uint_8_list *program_bytes,
                      struct wire_StringList *args_str);

void wire_get_puzzle_from_public_key(int64_t port_, struct wire_uint_8_list *pk);

struct wire_StringList *new_StringList_0(int32_t len);

struct wire_uint_32_list *new_uint_32_list_0(int32_t len);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_secret_key_from_seed);
    dummy_var ^= ((int64_t) (void*) wire_secret_key_public_key);
    dummy_var ^= ((int64_t) (void*) wire_secret_key_derive_path_hardened);
    dummy_var ^= ((int64_t) (void*) wire_secret_key_derive_path_unhardened);
    dummy_var ^= ((int64_t) (void*) wire_public_key_derive_path_unhardened);
    dummy_var ^= ((int64_t) (void*) wire_signature_sign);
    dummy_var ^= ((int64_t) (void*) wire_signature_is_valid);
    dummy_var ^= ((int64_t) (void*) wire_signature_aggregate);
    dummy_var ^= ((int64_t) (void*) wire_signature_verify);
    dummy_var ^= ((int64_t) (void*) wire_pub_mnemonic_to_entropy);
    dummy_var ^= ((int64_t) (void*) wire_pub_entropy_to_mnemonic);
    dummy_var ^= ((int64_t) (void*) wire_pub_entropy_to_seed);
    dummy_var ^= ((int64_t) (void*) wire_bytes_to_hex);
    dummy_var ^= ((int64_t) (void*) wire_hex_to_bytes);
    dummy_var ^= ((int64_t) (void*) wire_bytes_to_sha256);
    dummy_var ^= ((int64_t) (void*) wire_pub_master_to_wallet_unhardened_intermediate);
    dummy_var ^= ((int64_t) (void*) wire_pub_master_to_wallet_unhardened);
    dummy_var ^= ((int64_t) (void*) wire_pub_master_to_wallet_hardened_intermediate);
    dummy_var ^= ((int64_t) (void*) wire_pub_master_to_wallet_hardened);
    dummy_var ^= ((int64_t) (void*) wire_pub_master_to_pool_singleton);
    dummy_var ^= ((int64_t) (void*) wire_pub_master_to_pool_authentication);
    dummy_var ^= ((int64_t) (void*) wire_cmds_program_run);
    dummy_var ^= ((int64_t) (void*) wire_cmds_program_brun);
    dummy_var ^= ((int64_t) (void*) wire_cmd_program_opc);
    dummy_var ^= ((int64_t) (void*) wire_cmd_program_opd);
    dummy_var ^= ((int64_t) (void*) wire_cmd_program_cldb);
    dummy_var ^= ((int64_t) (void*) wire_program_tree_hash);
    dummy_var ^= ((int64_t) (void*) wire_program_curry);
    dummy_var ^= ((int64_t) (void*) wire_program_uncurry);
    dummy_var ^= ((int64_t) (void*) wire_program_from_list);
    dummy_var ^= ((int64_t) (void*) wire_program_disassemble);
    dummy_var ^= ((int64_t) (void*) wire_program_run);
    dummy_var ^= ((int64_t) (void*) wire_get_puzzle_from_public_key);
    dummy_var ^= ((int64_t) (void*) new_StringList_0);
    dummy_var ^= ((int64_t) (void*) new_uint_32_list_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}
