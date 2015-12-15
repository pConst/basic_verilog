
#define AJI_API

typedef int SLD_HUB_ID;
typedef int	SLD_NODE_ID;
typedef struct	{
    BYTE    inst_id;
    WORD    mfg_id;
    BYTE    node_id;
    BYTE    version;
} SLD_NODE_INFO;

typedef enum
{
    JTAGLINK_ERR_BAD_HARDWARE = -99,
    JTAGLINK_ERR_BAD_DEVICE,
    JTAGLINK_ERR_BAD_HUB,
    JTAGLINK_ERR_BAD_NODES,
    JTAGLINK_ERR_BAD_NODEINFO,
    JTAGLINK_ERR_BAD_NODEOPEN,
    JTAGLINK_ERR_BAD_NODELOCK,
    JTAGLINK_ERR_BAD_NODEUNLOCK,
    JTAGLINK_ERR_BAD_NODEACCESSIR,
    JTAGLINK_ERR_BAD_NODEACCESSDR,
};


typedef struct
{
    SLD_HUB_ID hub_id;
    SLD_NODE_INFO info;
    SLD_NODE_ID id;
    char hardware[0x20];
    char server[0x20];
    char port[0x20];
    char device[0x20];
    int offset;             //for all, offset in jtag chain, set by jtag_atlantic_init(), jtag_avalon_init()
    int data_length;        //for jtag_atlantic, length of data word (bits), set by jtag_atlantic_init()
    int addr_width;         //for jtag_avalon, width of address bus (bits), set by jtag_avalon_status()
    int data_width;         //for jtag_avalon, width of data bus (bits)
    int mode_width;         //for jtag_avalon, width of mode bus (bits)
} type_jtagnode;

//mfg_id
#define ALTERA_MFG_ID   0x6e

enum AJI_ERROR // These are transmitted from client to server so must not change.
{
	AJI_NO_ERROR               = 0,
	AJI_FAILURE                = 1,
	AJI_TIMEOUT                = 2,

	AJI_UNKNOWN_HARDWARE      = 32,
	AJI_INVALID_CHAIN_ID      = 33,
	AJI_LOCKED                = 34,
	AJI_NOT_LOCKED            = 35,

	AJI_CHAIN_IN_USE          = 36,
	AJI_NO_DEVICES            = 37,
	AJI_CHAIN_NOT_CONFIGURED  = 38,
	AJI_BAD_TAP_POSITION      = 39,
	AJI_DEVICE_DOESNT_MATCH   = 40,
	AJI_IR_LENGTH_ERROR       = 41,
	AJI_DEVICE_NOT_CONFIGURED = 42,
	AJI_CHAINS_CLAIMED        = 43,

	AJI_INVALID_OPEN_ID       = 44,
	AJI_INVALID_PARAMETER     = 45,
	AJI_BAD_TAP_STATE         = 46,
	AJI_TOO_MANY_DEVICES      = 47,
	AJI_IR_MULTIPLE           = 48,
	AJI_BAD_SEQUENCE          = 49,
	AJI_INSTRUCTION_CLAIMED   = 50,
	AJI_MODE_NOT_AVAILABLE    = 51, // The mode requested is not supported by this hardware

	AJI_FILE_ERROR            = 80,
	AJI_NET_DOWN              = 81,
	AJI_SERVER_ERROR          = 82,
	AJI_NO_MEMORY             = 83, // Out of memory when configuring 
	AJI_BAD_PORT              = 84, // Port number (eg LPT1) does not exist
	AJI_PORT_IN_USE           = 85,
	AJI_BAD_HARDWARE          = 86, // Hardware (eg byteblaster cable) not connected to port
	AJI_BAD_JTAG_CHAIN        = 87, // JTAG chain connected to hardware is broken
	AJI_SERVER_ACTIVE         = 88, // Another thread in this process is using the JTAG Server
	AJI_NOT_PERMITTED         = 89,

	AJI_UNIMPLEMENTED        = 126,
	AJI_INTERNAL_ERROR       = 127,

// These errors are generated on the client side only
	AJI_NO_HUBS              = 256,
	AJI_TOO_MANY_HUBS        = 257,
	AJI_NO_MATCHING_NODES    = 258,
	AJI_TOO_MANY_MATCHING_NODES = 259
};

// The AJI_HARDWARE class represents one chain attached to one hardware driver.
// This chain can either be a jtag chain or a passive serial chain (as
// indicated by chain_type).

typedef class AJI_CHAIN * AJI_CHAIN_ID;
typedef class AJI_OPEN  * AJI_OPEN_ID;

enum AJI_CHAIN_TYPE // These are transmitted from client to server so must not change.
{
	AJI_CHAIN_UNKNOWN = 0,
	AJI_CHAIN_JTAG    = 1,
	AJI_CHAIN_SERIAL  = 2,
	AJI_CHAIN_PASSIVE = 2, // Passive serial (EPC2 style)
	AJI_CHAIN_ACTIVE  = 3  // Active serial (Motorola SPI device)
};

enum AJI_PACK_STYLE // These are transmitted from client to server so must not change.
{
	AJI_PACK_NEVER  = 0,
	AJI_PACK_AUTO   = 1,
	AJI_PACK_MANUAL = 2
};

typedef struct AJI_HARDWARE AJI_HARDWARE;
struct AJI_HARDWARE
{
	AJI_CHAIN_ID   chain_id;
	DWORD          persistent_id;
	const char   * hw_name;     // Name of this type of hardware
	const char   * port;
	const char   * device_name; // Name given to hardware by user (or NULL)
	AJI_CHAIN_TYPE chain_type;
	const char   * server;      // Name of server this is attached to (NULL if local)
	DWORD          features;    // Logical or of AJI_FEATURE_xxx
};

// The AJI_DEVICE class represents the information which the server needs to
// know about one JTAG TAP controller on a JTAG chain.

typedef struct AJI_DEVICE AJI_DEVICE;
struct AJI_DEVICE
{
	DWORD         device_id;
	DWORD         mask;                 // 1 bit in mask indicates X in device_id
	BYTE          instruction_length;
	DWORD         features;             // Bitwise or of AJI_DEVFEAT
	const char  * device_name;          // May be NULL
};

enum AJI_CLAIM_TYPE
{
	AJI_CLAIM_IR                 = 0x0000, // Exclusive access to this IR value
	AJI_CLAIM_IR_SHARED          = 0x0100, // Shared access to this IR value
	AJI_CLAIM_IR_SHARED_OVERLAY  = 0x0300, // Shared access to this OVERLAY IR value
	AJI_CLAIM_IR_OVERLAID        = 0x0400, // Exclusive access to this OVERLAID IR value
	AJI_CLAIM_IR_SHARED_OVERLAID = 0x0500, // Shared access to this OVERLAID IR value
	AJI_CLAIM_IR_WEAK            = 0x0800, // Allow access to this IR value if unclaimed
	                                       // (value ~0 means all unclaimed IR values)

	AJI_CLAIM_OVERLAY            = 0x0001, // Exclusive access to this value in the OVERLAY DR
	AJI_CLAIM_OVERLAY_SHARED     = 0x0101, // Shared access to this value in the OVERLAY DR
	AJI_CLAIM_OVERLAY_WEAK       = 0x0801  // Allow access to this value in OVERLAY DR if unclaimed
	                                       // (value ~0 means all unclaimed OVERLAY DR values)
};

struct AJI_CLAIM
{
	AJI_CLAIM_TYPE type;
	DWORD value;
};

enum AJI_DR_FLAGS // These are transmitted from client to server so must not change.
{
	AJI_DR_UNUSED_0      = 1, // Allow zeros to be written to unspecified bits
	AJI_DR_UNUSED_0_OMIT = 3, // Allow zeros at the TDI end, allow any value at TDO end
	AJI_DR_UNUSED_X     = 15, // Allow any value to be written to unspecified bits
	AJI_DR_NO_SHORT     = 16  // Must clock all bits through (disable optimisations)
};

AJI_ERROR AJI_API aji_get_hardware            (DWORD              * hardware_count,
                                               AJI_HARDWARE       * hardware_list,
                                               DWORD                timeout = 0x7FFFFFFF);
AJI_ERROR AJI_API aji_lock_chain              (AJI_CHAIN_ID         chain_id,
                                               DWORD                timeout);

AJI_ERROR AJI_API aji_unlock_chain            (AJI_CHAIN_ID         chain_id);

AJI_ERROR AJI_API aji_lock                    (AJI_OPEN_ID          open_id,
                                               DWORD                timeout,
                                               AJI_PACK_STYLE       pack_style);

AJI_ERROR AJI_API aji_unlock                  (AJI_OPEN_ID          open_id);

AJI_ERROR AJI_API aji_access_ir               (AJI_OPEN_ID          open_id,
                                               DWORD                instruction,
                                               DWORD              * captured_ir,
                                               DWORD                flags = 0);

AJI_ERROR AJI_API aji_access_dr               (AJI_OPEN_ID          open_id,
                                               DWORD                length_dr,
                                               DWORD                flags,
                                               DWORD                write_offset,
                                               DWORD                write_length,
                                               const BYTE         * write_bits,
                                               DWORD                read_offset,
                                               DWORD                read_length,
                                               BYTE               * read_bits);

AJI_ERROR AJI_API aji_access_dr               (AJI_OPEN_ID          open_id,
                                               DWORD                length_dr,
                                               DWORD                flags,
                                               DWORD                write_offset,
                                               DWORD                write_length,
                                               const BYTE         * write_bits,
                                               DWORD                read_offset,
                                               DWORD                read_length,
                                               BYTE               * read_bits,
                                               DWORD                batch);

AJI_ERROR AJI_API aji_access_ir               (AJI_OPEN_ID          open_id,
                                               DWORD                length_ir,
                                               const BYTE         * write_bits,
                                               BYTE               * read_bits,
                                               DWORD                flags = 0);

AJI_ERROR AJI_API aji_get_nodes               (AJI_CHAIN_ID         chain_id,
                                               DWORD                tap_position,
                                               DWORD              * idcodes,
                                               DWORD              * idcode_n);

AJI_ERROR AJI_API aji_open_node               (AJI_CHAIN_ID         chain_id,
                                               DWORD                tap_position,
                                               DWORD                idcode,
                                               AJI_OPEN_ID        * node_id,
                                               const AJI_CLAIM    * claims,
                                               DWORD                claim_n,
                                               const char         * application_name);

AJI_ERROR AJI_API aji_get_node_info           (AJI_OPEN_ID          node_id,
                                               DWORD              * device_index,
                                               DWORD              * info);

AJI_ERROR AJI_API aji_read_device_chain       (AJI_CHAIN_ID         chain_id,
                                               DWORD              * device_count,
                                               AJI_DEVICE         * device_list,
                                               bool                 auto_scan = true);

AJI_ERROR AJI_API aji_close_device            (AJI_OPEN_ID          open_id);

AJI_ERROR AJI_API aji_access_overlay          (AJI_OPEN_ID          node_id,
                                               DWORD                overlay,
                                               DWORD              * captured_overlay);

enum INSTR { ACCESS_INSTR = 0, CONFIG_INSTR = 1, INVALID = ~0 };

static const AJI_CLAIM alt_jtaglib_claims[] = {
{ AJI_CLAIM_OVERLAY,        0 },
{ AJI_CLAIM_OVERLAY,        1 },
{ AJI_CLAIM_OVERLAY,        2 },
{ AJI_CLAIM_OVERLAY,        3 }
};

